json.holidays @holidays do |holiday|
  json.extract!(holiday, :id, :name, :date)
  json.url holiday_url(holiday)
  json.editUrl edit_holiday_url(holiday)
  json.calendarUrl main_calendar_url(search: holiday.name)
end
json.count @count
json.filter @filter
json.newUrl new_holiday_url()
