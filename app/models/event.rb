class Event < ActiveRecord::Base
  belongs_to :page
  validates_presence_of :page_id
  
  def self.find_between(start, stop)
    conditions = []
    conditions << "stop_at > '#{start.strftime("%Y-%m-%d %H:%M:%S")}'"
    conditions << "start_at < '#{stop.strftime("%Y-%m-%d %H:%M:%S")}'"
    conditions_sql = conditions.empty? ? nil : conditions.join(' AND ')
    self.find(:all, :conditions => conditions_sql, :order => 'start_at')
  end
  
  def self.calendar(start, stop)
    events = find_between(start, stop)
    
    calendar = Calendar.new(start, stop)
    calendar.weeks.each do |week|
      week.days.each do |day|
        carry_over_events = []
        while not events.empty? and events.first.start_at.to_date < (day.date + 1)
          event = events.shift
          day.events << event
          # hold on to re-insert for the next day
          carry_over_events << event if event.stop_at.to_date != day.date.to_date
        end
        # re-insert multi-day events
        carry_over_events.reverse.each{|e| events.unshift(e)}
      end
    end
    
    calendar
  end
  
end
