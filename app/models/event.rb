class Event < ActiveRecord::Base
  belongs_to :page
  belongs_to :master, :class_name => 'Event'
  has_many :replicas, :class_name => 'Event', :foreign_key => :master_id,
    :autosave => true
  has_many :reservations
  has_many :resources, :through => :reservations
  
  validates_presence_of :page, :name, :start_at, :stop_at
  
  before_save do
    self.replicas.each do |replica|
      replica.name = self.name if replica.name != self.name
      replica.location = self.location if replica.location != self.location
    end
  end
  
  def self.find_between(start, stop)
    conditions = []
    conditions << "stop_at > '#{start.strftime("%Y-%m-%d %H:%M:%S")}'"
    conditions << "start_at < '#{stop.strftime("%Y-%m-%d %H:%M:%S")}'"
    conditions_sql = conditions.empty? ? nil : conditions.join(' AND ')
    self.find(:all, :conditions => conditions_sql, :order => 'start_at')
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
