event ||= @event
json.extract!(event, :name, :start_at, :stop_at, :location)
json.friendlyTimes contextual_times(event)
json.calendarUrl main_calendar_url(
  :search => event.name + " " + event.start_at.strftime("%B %Y"))
