module CalendarHelper
  
  def date_class(day, reference)
    date = day.date
    tags = []
    tags << 'first' if 0 == date.wday
    tags << 'new_month_first' if 1 == date.day
    tags << 'new_month' if (1..7).to_a.include?(date.day)
    tags << 'ref' if date.yday == reference.yday
    tags << 'holiday' unless day.holidays.empty?
    return '' if tags.empty?
    return "class=\"#{tags.join(' ')}\""
  end
  
end
