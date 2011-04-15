class Event < ActiveRecord::Base
  belongs_to :page
  belongs_to :master, :class_name => 'Event'
  has_many :replicas, :class_name => 'Event', :foreign_key => :master_id,
    :autosave => true, :dependent => :destroy
  has_many :reservations
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
  
  def self.upcoming
    # tried to do this in Arel but gave up
    sql = "SELECT id FROM events, " +
      "(SELECT master_id, min(start_at) as start_at FROM events " +
      " GROUP BY master_id) as master_times " +
      "WHERE events.master_id = master_times.master_id AND " +
      "events.start_at = master_times.start_at " +
      "UNION " +
      "(SELECT id FROM events WHERE master_id IS NULL)"
    ids = find_by_sql(sql)
    where(:id => ids)
  end
  
  before_save do
    # update replicas, TODO: add reservations!
    self.replicas.each do |replica|
      replica.name = self.name if replica.name != self.name
      replica.location = self.location if replica.location != self.location
    end
  end
  
  #def self.find_between(start, stop)
  #  conditions = []
  #  conditions << "stop_at > '#{start.strftime("%Y-%m-%d %H:%M:%S")}'"
  #  conditions << "start_at < '#{stop.strftime("%Y-%m-%d %H:%M:%S")}'"
  #  conditions_sql = conditions.empty? ? nil : conditions.join(' AND ')
  #  self.find(:all, :conditions => conditions_sql, :order => 'start_at')
  #end
  
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
