class Event < ActiveRecord::Base
  belongs_to :page
  belongs_to :master, :class_name => 'Event'
  has_many :replicas, :class_name => 'Event', :foreign_key => :master_id,
    :order => :start_at, :autosave => true
  has_many :reservations, :autosave => true, :dependent => :destroy,
    :include => :resource
  has_many :resources, :through => :reservations
  has_many :invitations, :dependent => :destroy, :order => :email
  acts_as_audited
  
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
    if master and master.master
      errors.add(:master_id, "can't be a replica of a replica")
    end
  end
  
  searchable do
    text :name, :default_boost => 1
    time :start_at
    boolean :best do |event|
      not event.master_id or event.master_id == event.id
    end
  end
  
  def self.on_or_after(date)
    where("events.start_at >= ?", date)
  end
  def self.between(start, stop)
    where("events.stop_at > ? AND events.start_at < ?", start, stop)
  end
  #scope :masters,
  #  where("events.master_id = events.id OR events.master_id IS NULL")
  
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
          result[:ancient] << e
        end
        result[:all] << e
      end
    end
    result
  end
  
  # find the replica that is the closest to today, preferably in the future
  def best_replica(events)
    return self if (not master_id) and replicas.empty? # no replicas
    today = Time.now.beginning_of_day
    candidate = self
    events.each do |e|
      # are we related?
      next unless e.master_id == self.id or self.master_id == e.id or
        (self.master_id and e.master_id == self.master_id)

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
      become_master
      # update replicas, including reservations
      self.replicas.each do |replica|
        replica.name = self.name
        replica.location = self.location
        replica.align_reservations(self)
        replica.save
      end
    end
  end
  
  def align_reservations(source_event)
    self.reservations.clear
    source_event.reservations.each do |reservation|
      self.reservations << reservation.copy(self)
    end
  end
  
  def master_and_replicas
    result = if master
        master.replicas.all.dup + [master]
      elsif not replicas.empty?
        replicas.all.dup + [self]
      else
        [self]
      end
    result.sort{|e1, e2| e1.start_at <=> e2.start_at}
  end
  
  def replicate(dates)
    #logger.info "!!! replicate to #{dates.map{|e| e.to_s}.join(', ')}"
    Event.transaction do
      # throw out everything related except me
      if master
        master.replicas.delete(self)
        master.replicas.each{|e| e.destroy}
        master.destroy
      else
        replicas.each{|e| e.destroy}
      end
      
      remaining_dates = dates.dup
      # set me to first date
      adjust_dates(remaining_dates.shift)
      save
      remaining_dates.each do |date|
        replicas << copy(date)
      end
    end
  end
  
  def possible_pages
    Page.order('name')
  end
  
  private
  
  def adjust_dates(date)
    duration = self.stop_at - self.start_at
    new_start_at = Time.parse(date.strftime("%Y-%m-%d") +
      self.start_at.strftime(" %H:%M %z"))
    self.start_at = new_start_at
    self.stop_at = (new_start_at + duration)
  end
  
  def copy(date)
    duration = self.stop_at - self.start_at
    new_start_at = Time.parse(date.strftime("%Y-%m-%d") +
      self.start_at.strftime(" %H:%M %z"))
    params = {:name => self.name, :location => self.location,
      :start_at => new_start_at,
      :stop_at => (new_start_at + duration),
      :featured => self.featured}
    new_event = Event.new(params)
    new_event.page = self.page
    self.reservations.each do |reservation|
      new_event.reservations << reservation.copy(new_event)
    end
    new_event
  end
  
  def become_master
    return unless master
    tmp = master.replicas.all.dup
    master.replicas.clear
    replicas << master
    tmp.each{|e| replicas << e unless e == self}
  end
  
end
