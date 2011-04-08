class Calendar
  def initialize(start, stop)
    @weeks = []
    date = start.tomorrow.beginning_of_week.yesterday.to_date
    while (date <= stop.to_date) do
      @weeks << Week.new if 0 == date.wday
      day = Day.new(date)
      @weeks[-1].days << day
      date = date + 1
    end
  end
  attr_reader :weeks
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
