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

  def event_date
    strftime("%A") + " %d/%d" % [mon, day]
  end

end

class Date

  # align with datepicker format used
  HUMAN_FORMAT =  '%m/%d/%Y'
  MACHINE_FORMAT = '%Y-%m-%d'

  # parses the date in the event form into a Date object
  def self.parse_from_form(str)
    return nil unless str
    # allow any reasonable format
    if str =~ /\//
      strptime(str, HUMAN_FORMAT)
    else
      strptime(str, MACHINE_FORMAT)
    end
  end

  def relative_str(show_year=false)
    if not show_year and self.year == Date.today.year
      strftime("%B ") + mday.ordinalize
    else
      strftime("%B ") + mday.ordinalize + strftime(" %Y")
    end
  end
end


class DateTime

  # align with datetimepicker format used DEPRECATED
  HUMAN_YEAR_FORMAT =  '%m/%d/%Y'
  HUMAN_TIME_FORMAT = '%I:%M %p'
  FORM_SEPARATOR = ' @ '

  # parses the date+time in the event form into a DateTime object
  # takes care of timezone and daylight savings time issues
  def self.parse_from_form(str)
    return nil unless str
    if str =~ /\//
      format = HUMAN_YEAR_FORMAT + FORM_SEPARATOR + HUMAN_TIME_FORMAT
      wrong_zone = strptime(str, format)
    else
      wrong_zone = DateTime.iso8601(str);
    end
    right_zone = Time.zone.parse(wrong_zone.strftime('%Y-%m-%d %H:%M:%S'))
  end

end
