event ||= @event
json.event do
  json.extract!(event, :name, :start_at, :stop_at, :location)
  json.friendlyTimes contextual_times(event)
end
