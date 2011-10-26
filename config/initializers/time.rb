require 'calendar'

class Time

  def simple_time(meridian=true)
    (0 == self.min ? self.strftime("%l") : self.strftime("%l:%M")).strip +
      (meridian ? self.strftime("%p").downcase : '')
  end

  def simple_date
    "%d/%d" % [self.mon, self.mday]
  end
  
  def relative_str(show_year=true)
    if not show_year or self.year == Date.today.year
      strftime("%b ") + mday.ordinalize
    else
      strftime("%Y %b ") + mday.ordinalize
    end
  end

end

class Date
  
  # align with datepicker format used
  FORM_YEAR_FORMAT =  '%m/%d/%Y'
  
  # parses the date in the event form into a Date object
  def self.parse_from_form(str)
    return nil unless str
    strptime(str, FORM_YEAR_FORMAT)
  end
  
end


class DateTime
  
  # align with datetimepicker format used
  FORM_YEAR_FORMAT =  '%m/%d/%Y'
  FORM_TIME_FORMAT = '%I:%M %p'
  FORM_SEPARATOR = ' @ '
  
  # parses the date+time in the event form into a DateTime object
  # takes care of timezone and daylight savings time issues
  def self.parse_from_form(str)
    return nil unless str
    # extract the date portion
    utc_date = strptime(str, FORM_YEAR_FORMAT)
    # convert to a local one, force the right zone by adding an hour
    local_date = Time.local(utc_date.year, utc_date.month, utc_date.day, 1)
    format = FORM_YEAR_FORMAT + FORM_SEPARATOR + FORM_TIME_FORMAT + " %Z"
    # parse the whole thing using the local time zone for that day
    strptime(str + " " + local_date.zone, format)
  end
  
end
