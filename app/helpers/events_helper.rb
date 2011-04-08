module EventsHelper
  
  def friendly_range(event, with_date=true)
    if with_date or event.start_at.to_date != event.stop_at.to_date
      event.start_at.strftime("%A") + " %d/%d" %
        [event.start_at.mon, event.start_at.day] + ' '
    else
      ''
    end +
    if event.start_at.to_date == event.stop_at.to_date
      if (event.start_at.hour / 12) == (event.stop_at.hour / 12)
        event.start_at.simple_time(false) + '-' + event.stop_at.simple_time(true)
      else
        event.start_at.simple_time(true) + '-' + event.stop_at.simple_time(true)
      end
    else
      # start and stop on different days
      event.start_at.simple_time(true) +
      " - " + event.stop_at.strftime("%A") + " %d/%d" %
        [event.stop_at.mon, event.stop_at.day] + ' ' +
      event.stop_at.simple_time(true)
    end
  end
  
end
