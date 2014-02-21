class Event < ActiveRecord::Base
  belongs_to :page
  has_many :event_pages, :dependent => :destroy
  has_many :shared_pages, :through => :event_pages, :class_name => 'Page',
    :source => :page
  belongs_to :master, :class_name => 'Event'
  has_many :replicas, -> { order(:start_at) }, :class_name => 'Event',
    :foreign_key => :master_id
  has_many :reservations, :dependent => :destroy
  has_many :resources, :through => :reservations
  has_many :invitations, -> { order(:email) }, :dependent => :destroy
  has_many :forms, -> { order('LOWER(name) ASC') }, :dependent => :destroy
  has_many :events_messages, :dependent => :destroy, :class_name => 'EventMessage'
  has_many :messages, :through => :events_messages, :source => :message
  belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by'
  
  validates_presence_of :page, :name, :stop_at
  validates :start_at, :presence => true,
    :uniqueness => {:scope => :master_id,
      :unless => Proc.new{|p| not p.master_id and not p.master}}
  validate :start_before_stop
  validate :no_master_if_replicas
  
  def start_before_stop
    if stop_at and start_at and stop_at < start_at
      errors.add(:stop_at, "can't be before start")
    end
  end
  
  def no_master_if_replicas
    if slave? and master.master and master.master != master
      errors.add(:master_id, "can't be a replica of a replica (master: #{master.id}, master.master: #{master.master.id})")
    end
  end
  
  searchable do
    text :name, :default_boost => 1
    time :start_at
    boolean :best do |event| not event.slave? end
  end
  
  def self.on_or_after(date)
    where("events.start_at >= ?", date)
  end
  
  def self.between(start, stop)
    where("events.stop_at > ? AND events.start_at < ?", start, stop)
  end
  
  scope :masters,
    -> { where("events.master_id = events.id OR events.master_id IS NULL") }
    
  scope :featured,
    -> { where("events.featured = 't'") }
  
  def related_to?(event)
    event.master and self.master == event.master
  end
  
  def slave?
    master and self != master
  end
  
  def regular?
    master and
    master.replicas.between(Date.today, Date.today + 1.month).count > 2
  end
  
  def occasional?
    master and
    master.replicas.between(Date.today, Date.today + 1.month).count <= 2
  end
  
  def singular?
    not master or master.replicas.count <= 1
  end
  
  def authorized?(user)
    return (page and page.authorized?(user))
  end
  
  def searchable?(user)
    return (page and page.searchable?(user))
  end
  
  def for_user?(user)
    return (page and page.for_user?(user))
  end
  
  def global_name_or_name
    (global_name and not global_name.empty?) ? global_name : name
  end
  
  def top_context
    ancestors = page.ancestors
    if ancestors.length > 1
      page.ancestors.slice(1).name
    else
      page.name
    end
  end
  
  def invitation_for_user(user)
    return nil unless user
    invitations.where('user_id = ?', user).first
  end
  
  def filled_forms_for_user(user)
    return [] unless user
    forms.filled_forms.where('filled_forms.user_id = ?', user)
  end
  
  def peers
    if master
      master.replicas
    else
      [self]
    end
  end
  
  def next
    if master
      master.replicas.where("start_at > '#{start_at}' AND id != #{id}").first
    else
      nil
    end
  end
  
  def prev
    if master
      master.replicas.where("start_at < '#{start_at}' AND id != #{id}").last
    else
      nil
    end
  end
  
  def peers_until(date)
    if master
      master.replicas.where("start_at > '#{start_at}' AND id != #{id} AND start_at <= '#{date}'")
    else
      Event.none
    end
  end
  
  # divide the events up into three categories: active, expired, ancient
  # prune out replicas
  def self.categorize(events)
    result = {:active => [], :expired => [], :ancient => [], :all => []}
    today = Time.now.beginning_of_day
    ancient_threshold = today - 3.months
    events.each do |e|
      if e == e.best_replica(events)
        # no replicas or the best replica
        if e.stop_at >= today
          result[:active] << e
        elsif e.stop_at >= ancient_threshold
          result[:expired] << e
        else
          result[:ancient].unshift(e)
        end
        result[:all] << e
      end
    end
    result
  end
  
  # find the replica that is the closest to today, preferably in the future
  def best_replica(events)
    return self if not master or master.replicas.empty? # no replicas
    today = Time.now.beginning_of_day
    candidate = self
    events.each do |e|
      # are we related?
      next unless self.related_to?(e)

      if e.start_at >= today and (candidate.start_at > e.start_at or
        candidate.start_at < today)
        # today or later but sooner than candidate
        candidate = e
      elsif e.start_at < today and candidate.start_at < e.start_at
        # earlier than today but later than candidate
        candidate = e
      end
      
    end
    candidate
  end
  
  def update_with_replicas(attrs={})
    Event.transaction do
      update_attributes(attrs)
      # make me the master
      #become_master
      # update replicas, including reservations
      tmp_peers = peers
      self.master = self
      tmp_peers.each do |peer|
        peer.master = self
        if self != peer
          peer.name = self.name
          peer.start_at = Time.parse(peer.start_at.strftime("%Y-%m-%d") +
            self.start_at.strftime(" %H:%M")) # don't include timezone!
          peer.stop_at = Time.parse(peer.stop_at.strftime("%Y-%m-%d") +
            self.stop_at.strftime(" %H:%M")) # don't include timezone!
          peer.location = self.location
          peer.featured = self.featured
          peer.global_name = self.global_name
          peer.notes = self.notes
          peer.all_day = self.all_day
          peer.page = self.page
          peer.align_reservations(self)
        end
        peer.save!
      end
    end
  end
  
  def align_reservations(source_event)
    self.reservations.clear
    source_event.reservations.each do |reservation|
      self.reservations << reservation.copy(self)
    end
  end
  
  def replicate(dates)
    current_dates = peers.map{|e| e.start_at.to_date}

    tmp_peers = peers
    new_peers = []
    copied_peers = []
    new_master = self
    errors = []

    begin
      Event.transaction do
      
        # add new ones that we don't have yet
        # do this first in case we destroy this event
        dates.each do |date|
          if not current_dates.include?(date)
            peer = copy(date)
            peer.reservations.clear # handle later
            new_peers << peer
            copied_peers << peer
          end
        end
      
        # remove existing dates that aren't specified
        tmp_peers.each do |peer|
          if not dates.include?(peer.start_at.to_date)
            new_master = nil if self == peer
            peer.destroy
          else
            new_peers << peer
          end
        end
      
        # pick new master
        if new_master
          self.master = new_master # so validation of prior peers works
        else
          # we've destroyed ourself, pick a new master
          new_master = new_peers.first
          # now, we need to save this new master with a master_id pointing to itself
          # need to save it w/o a master_id first so we generate an id
          new_master.save!
          new_master.master = new_master
        end

        new_peers.each do |peer|
          peer.master = new_master
          peer.save!
        end
      
        # we copy the reservations after creating the new events so they have ids
        copied_peers.each do |peer|
          self.reservations.each do |reservation|
            new_reservation = reservation.copy(peer)
            if not new_reservation.save
              errors.concat(new_reservation.errors.full_messages)
            end
          end
        end
        
        unless errors.empty?
          raise ActiveRecord::Rollback
        end
      end
    rescue ActiveRecord::RecordInvalid
      new_master = nil
    end
    
    errors.empty? ? new_master : errors
  end
  
  private
  
  def copy(date)
    duration = self.stop_at - self.start_at
    new_start_at = Time.parse(date.strftime("%Y-%m-%d") +
      self.start_at.strftime(" %H:%M")) # don't include timezone!
    params = {:name => self.name, :location => self.location,
      :start_at => new_start_at,
      :stop_at => (new_start_at + duration),
      :featured => self.featured,
      :notes => self.notes}
    new_event = Event.new(params)
    new_event.page = self.page
    self.reservations.each do |reservation|
      new_event.reservations << reservation.copy(new_event)
    end
    new_event
  end
  
  def become_master
    if master and self != master
      self.replicas = master.replicas
      master.replicas.clear
      self.replicas.each{|e| e.master = self}
    end
  end
  
end
