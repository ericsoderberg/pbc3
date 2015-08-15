json.resources @resources do |resource|
  json.extract!(resource, :id, :name)
  json.url resource_url(resource)
  json.editUrl edit_resource_url(resource)
  json.calendarUrl main_calendar_url(search: resource.name)
end
json.count @count
json.filter @filter
json.newUrl new_resource_url()
