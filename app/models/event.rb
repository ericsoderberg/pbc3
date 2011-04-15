class Event < ActiveRecord::Base
  belongs_to :page
  belongs_to :master, :class_name => 'Event'
  has_many :replicas, :class_name => 'Event', :foreign_key => :master_id,
    :autosave => true, :dependent => :destroy
  has_many :reservations, :dependent => :destroy
  has_many :resources, :through => :reservations
  
  validates_presence_of :page, :name, :start_at, :stop_at
  validate :start_before_stop
  
  def start_before_stop
    if stop_at and start_at and stop_at < start_at
      errors.add(:stop_at, "can't be before start")
    end
  end
  
  def self.on_or_after(date)
    where("events.start_at >= ?", date)
  end
  def self.between(start, stop)
    where("events.stop_at > ? AND events.start_at < ?", start, stop)
  end
  scope :masters,
    where("events.master_id = events.id OR events.master_id IS NULL")
  
  def self.prune(events)
    today = Time.now.beginning_of_day
    events.select do |e|
      # today or later
      e.stop_at >= today and
      # nothing better
      not events.detect{|e2|
        # not the same
        (e2 != e) and
        # later than today
        (e2.stop_at >= today) and
        # not both masters
        (e2.master_id or e.master_id) and
        # related
        (e2.master_id == e.master_id or
         e2.id == e.master_id or
         e2.master_id == e.id) and
        # e2 earlier than e?
        (e2.start_at < e.start_at)
      }
    end
  end
  
  before_save do
    # update replicas, TODO: add reservations!
    self.replicas.each do |replica|
      replica.name = self.name if replica.name != self.name
      replica.location = self.location if replica.location != self.location
    end
  end
  
  def replicate(dates)
    # remove existing events that aren't checked
    replicas.each do |event|
      next if event == self
      next if dates.include?(event.start_at.to_date)
      event.destroy
    end
    # add new ones that we don't have yet
    existing = replicas.map{|e| e.start_at.to_date}
    dates.each do |date|
      next if existing.include?(date)
      replicas << copy(date)
    end
  end
  
  private
  
  def copy(date)
    duration = self.stop_at - self.start_at
    new_start_at = Time.parse(date.strftime("%Y-%m-%d") +
      self.start_at.strftime(" %H:%M %z"))
    logger.info("!!! copy #{date} from #{self.start_at} to get #{new_start_at}")
    params = {:name => self.name, :location => self.location,
      :start_at => new_start_at,
      :stop_at => (new_start_at + duration),
      :page_id => self.page_id}
    Event.new(params)
  end
  
end
