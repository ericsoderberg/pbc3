daysOfWeek = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)

#json.start @calendar.start
#json.stop @calendar.stop
json.daysOfWeek daysOfWeek
json.weeks @calendar.weeks do |week|
  json.days week.days do |day|
    json.date day.date
    json.events day.events do |event|
      json.extract!(event, :name, :start_at, :stop_at, :location)
      #json.friendlyTimes contextual_times(event)
      json.url event_link(event)
    end
    json.holidays day.holidays do |holiday|
      json.extract! holiday, :name, :date
    end
  end
end
json.filter @filter
