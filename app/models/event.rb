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
    if slave? and master.master
      errors.add(:master_id, "can't be a replica of a replica")
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
    where("events.master_id = events.id OR events.master_id IS NULL")
    
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
      become_master
      # update replicas, including reservations
      self.replicas.each do |replica|
        next if self == replica
        replica.name = self.name
        replica.location = self.location
        replica.align_reservations(self)
        replica.master_id = self.id
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
  
  def replicate(dates)
    #logger.info "!!! replicate to #{dates.map{|e| e.to_s}.join(', ')}"
    Event.transaction do
      dereplicate
      
      remaining_dates = dates.dup
      # set me to first date
      adjust_dates(remaining_dates.shift)
      self.master_id = self.id
      #logger.info "!!! #{self.master_id}"
      remaining_dates.each do |date|
        slave = copy(date)
        slave.master_id = self.id
        slave.save
      end
      save
    end
  end
  
  def self.re_replicate
    Event.all.each do |event|
      next if event.replicas.empty? # skip singles and slaves
      next if event.replicas.exists?(:id => event.id) # already converted
      event.master = event
      event.save
    end
  end
  
  def authorized?(user)
    return page.authorized?(user)
  end
  
  private
  
  def adjust_dates(date)
    duration = self.stop_at - self.start_at
    new_start_at = self.start_at.change(:year => date.year, :month => date.month, :day => date.day)
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
    return unless master and self != master
    tmp = master.replicas.all.dup
    master.replicas.clear
    tmp.each{|e| replicas << e}
  end
  
  def dereplicate
    if master
      # throw out everything related except me
      master.replicas.delete(self)
      master.replicas.each{|e| e.destroy}
      self.master = nil
      self.save
    end
  end
  
end
