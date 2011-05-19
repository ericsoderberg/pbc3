module CalendarHelper
  
  def date_class(day, reference, active=false)
    date = day.date
    tags = []
    tags << 'first' if 0 == date.wday
    tags << 'new_month_first' if 1 == date.day
    tags << 'new_month' if (1..7).to_a.include?(date.day)
    tags << 'ref' if date.yday == reference.yday
    tags << 'active' if active
    tags << 'holiday' unless day.holidays.empty?
    return '' if tags.empty?
    return "class=\"#{tags.join(' ')}\""
  end
  
  def calendar_path(args)
    if args[:page_id]
      page_calendar_path(args)
    elsif args[:resource_id]
      resource_calendar_path(args)
    else
      main_calendar_path(args)
    end
  end
  
  def calendar_list_path(args)
    if args[:page_id]
      page_calendar_list_path(args)
    elsif args[:resource_id]
      resource_calendar_list_path(args)
    else
      main_calendar_list_path(args)
    end
  end
  
  def calendar_day_path(args)
    if args[:page_id]
      page_calendar_day_path(args)
    elsif args[:resource_id]
      resource_calendar_day_path(args)
    else
      main_calendar_day_path(args)
    end
  end
  
  def previous_month_path(args)
    previous_args = args.merge(:date =>
      (@date.beginning_of_month-1.month).strftime("%Y-%m-%d"))
    if 'list' == params[:action]
      calendar_list_path(previous_args)
    else
      calendar_path(previous_args)
    end
  end
  
  def next_month_path(args)
    next_args = args.merge(:date =>
      (@date.end_of_month+1.day).strftime("%Y-%m-%d"))
    if 'list' == params[:action]
      calendar_list_path(next_args)
    else
      calendar_path(next_args)
    end
  end
  
  def date_search_path(args)
    if 'list' == params[:action]
      calendar_list_path(args)
    else
      calendar_path(args)
    end
  end
  
end
