class Calendar

  def initialize(start, stop)
    @weeks = []
    if start == stop
      @weeks << Week.new
      @weeks[-1].days << Day.new(start)
      @start = @stop = start
    else
      date = @start = start.tomorrow.beginning_of_week.yesterday.to_date
      @stop = stop = stop.tomorrow.end_of_week.yesterday.to_date
      while (date <= stop.to_date) do
        @weeks << Week.new if 0 == date.wday
        day = Day.new(date)
        @weeks[-1].days << day
        date = date + 1
      end
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

class SearchDate
  def self.matches(text)
    result = nil
    terms = text.strip.split(' ')
    index = 0

    while index < terms.length and not result
      term = terms[index]
      next_term = terms[index+1]
      next_next_term = terms[index+2]
      score = 0

      # check for month
      months = (1..12).map{|i| Date::MONTHNAMES[i]}.select{|m| m.match(/^#{term}/i)}
      if not months.empty?
        range = nil

        # check for day or year following month
        # e.g. "May 2", "May 20", "May 201", "May 2014"
        if months.length == 1 and next_term and next_term.match(/^\d{1,4}$/)
          matches = months.map{|m| "#{m} #{next_term}"}
          if matches.length == 1
            if next_term.match(/^\d{4}$/)
              # e.g. "May 2014"
              date = Date.parse(matches[0])
              range = [date, date.end_of_month]
              score += 1
            elsif next_term.match(/^\d{1,2}$/)
              # e.g. "May 4", "May 4 2015"
              if next_next_term and next_next_term.match(/^\d{4}$/)
                # e.g. "May 4 2015"
                matches = months.map{|m| "#{m} #{next_term} #{next_next_term}"}
              else
                # e.g. "May 4"
                matches = months.map{|m| "#{m} #{next_term} #{Date.today.year}"}
              end
              date = Date.parse(matches[0])
              range = [date, date]
              score += 1
            end
          end
          term += ' ' + next_term
          index += 1
          next_term = terms[index+1]
        else
          # just month, e.g. "May"
          matches = months.map{|m| "#{m} #{Date.today.year}"}
          if matches.length == 1
            date = Date.parse(matches[0])
            range = [date, date.end_of_month]
            score += 1 if months[0] == term
          end
        end

        result = {type: 'date', text: term, matches: matches, score: score, range: range}

      # check for short form
      elsif term.match(/^\d{1,2}\/\d{1,2}\/\d{4}$/)
        # e.g. "5/2/2015"
        date =  Date.strptime(term, "%m/%d/%Y")
        range = [date, date]
        result = {type: 'date', text: term, matches: [term], score: 1, range: range}
      elsif term.match(/^\d{1,2}\/\d{1,2}$/)
        # e.g. "5/2"
        matches = ["#{term}/#{Date.today.year}"]
        date =  Date.strptime(matches[0], "%m/%d/%Y")
        range = [date, date]
        result = {type: 'date', text: term, matches: [term], score: 1, range: range}
      elsif term.match(/^\d{1,2}\/\d{4}$/)
        # e.g. "5/2015"
        matches = [term]
        date = Date.parse(matches[0])
        range = [date, date]
        result = {type: 'date', text: term, matches: [term], score: 1, range: range}

      # check for year
      elsif term.match(/^1$|^19$|^19\d{1,2}$|^2$|^20$|^20\d{1,2}$/)
        number = term.to_i
        if number < 10
          year = ["#{term}999".to_i, Date.today.year+1].min
          matches = (0..4).map{|i| year - i}
        elsif number < 100
          year = ["#{term}99".to_i, Date.today.year+1].min
          matches = (0..4).map{|i| year - i}
        elsif number < 1000
          year = ["#{term}9".to_i, Date.today.year+1].min
          matches = (0..4).map{|i| year - i}
        else
          year = term
          matches = [term]
          score += 1
        end
        range = [Date.parse("1/#{year}"), Date.parse("12/#{year}")]
        result = {type: 'date', text: term, matches: matches, score: score,
          range: range}
      else

        index += 1
      end
    end

    result
  end
end
