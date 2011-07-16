class Calendar
  
  def initialize(start, stop)
    @weeks = []
    date = @start = start.tomorrow.beginning_of_week.yesterday.to_date
    @stop = stop
    while (date <= stop.to_date) do
      @weeks << Week.new if 0 == date.wday
      day = Day.new(date)
      @weeks[-1].days << day
      date = date + 1
    end
  end
  
  attr_reader :weeks, :start, :stop
  
  def populate(events, holidays=[])
    weeks.each do |week|
      week.days.each do |day|
        carry_over_events = []
        while not events.empty? and
          events.first.start_at.to_date < (day.date + 1)
          
          event = events.shift
          day.events << event
          # hold on to re-insert for the next day
          carry_over_events << event if event.stop_at.to_date > day.date.to_date
        end
        
        # re-insert multi-day events
        carry_over_events.reverse.each{|e| events.unshift(e)}
        
        # add holidays
        if holidays.first and holidays.first.date == day.date
          day.holidays << holidays.shift
        end
      end
    end
  end
  
end

class Week
  def initialize
    @days = []
  end
  attr_reader :days
end

class Day
  def initialize(date)
    @date = date
    @events = []
    @holidays = []
  end
  attr_reader :date, :events, :holidays
end
