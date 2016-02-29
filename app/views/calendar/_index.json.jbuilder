daysOfWeek = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)

#json.start @calendar.start
#json.stop @calendar.stop
if @calendar.start != @calendar.stop
  json.daysOfWeek daysOfWeek
else
  json.daysOfWeek daysOfWeek.slice(@calendar.start.wday, 1)
end
json.weeks @calendar.weeks do |week|
  json.days week.days do |day|
    json.date day.date
    json.events day.events do |event|
      json.extract!(event, :name, :start_at, :stop_at, :location)
      #json.friendlyTimes contextual_times(event)
      if event.page
        json.url friendly_page_path(event.page)
        json.path friendly_page_path(event.page)
      else
        json.url edit_event_path(event)
      end
    end
    json.holidays day.holidays do |holiday|
      json.extract! holiday, :name, :date
    end
  end
end
json.newUrl new_event_url()
json.filter @filter
json.next @next
json.previous @previous
