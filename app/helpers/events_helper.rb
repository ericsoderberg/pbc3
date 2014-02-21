module EventsHelper
  
  def friendly_range(event, with_date=true)
    if with_date or event.start_at.to_date != event.stop_at.to_date
      event.start_at.strftime("%A ") + 
      if (Time.now - event.start_at) > (365 * 24 * 3600)
        "%d/%d/%d " % [event.start_at.mon, event.start_at.day, event.start_at.year]
      else
        "%d/%d " % [event.start_at.mon, event.start_at.day]
      end
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
  
  def peer_ranges(peers)
    ranges = {} # range => {events}
    peers.each do |event|
      range = friendly_range(event, false)
      ranges[range] = {events: []} unless ranges[range]
      ranges[range][:events] << event
    end
    ranges
  end
  
  def contextual_month_peers(peers, result)
    ranges = peer_ranges(peers)
    ranges.each do |range, data|
      event = data[:events].first
      if peers.count <= 2
        peers.each{|e| result << friendly_range(e, true)}
      elsif data[:events].count > 1
        result << (event.start_at.strftime("%As ") + range)
      else
        result << friendly_range(event, true)
      end
    end
  end
  
  def contextual_week_peers(peers, result)
    ranges = peer_ranges(peers)
    ranges.each do |range, data|
      event = data[:events].first
      if data[:events].count > 1
        first = data[:events].first
        last = data[:events].last
        if (last.start_at.to_date - first.start_at.to_date).round == (data[:events].count - 1)
          days = first.start_at.strftime('%a ') +
            "%d/%d" % [first.start_at.mon, first.start_at.day] + ' - ' +
            last.start_at.strftime('%a ') + 
            "%d/%d" % [last.start_at.mon, last.start_at.day]
        else
          days = data[:events].map do |e|
            e.start_at.strftime('%a ') +
            "%d/%d" % [e.start_at.mon, e.start_at.day]
          end.join(', ')
        end
        result << (days + ' ' + range)
      else
        result << friendly_range(event, true)
      end
    end
  end
  
  def contextual_times(event)
    # returns a list of event times to show for this event
    result = []
    month_peers = event.peers_until(event.start_at + 2.months)
    week_peers = event.peers_until(event.start_at + 1.week)
    if month_peers.empty?
      # just show this single date/time
      result << friendly_range(event, true)
    elsif week_peers.empty?
      # next one is more than a week away
      contextual_month_peers([event].concat(month_peers.to_a()), result)
    else
      # peers in the same week
      contextual_week_peers([event].concat(week_peers.to_a()), result)
    end
    
=begin
    next_event = event.next
    if not next_event or (next_event.start_at > (event.start_at + 2.months))
      # no close future times, just show this single date/time
      result << friendly_range(event, true)
    else
      next_next_event = next_event.next
      if not next_next_event or (next_event.start_at > (event.start_at + 1.week))
        # only one upcoming event, or next one more than a week away, show both
        result << friendly_range(event, true)
        result << friendly_range(next_event, true)
      else
        # >= 2 upcoming events
        range = friendly_range(event, false)
        next_range = friendly_range(next_event, false)
        next_next_range = friendly_range(next_next_event, false)
        if range == next_range and range == next_next_range
          # they're all at the same time, show an aggregate
          result << (event.start_at.strftime("%As ") +
            friendly_range(event, false))
        elsif range != next_range and range != next_next_range and
          next_range != next_next_range
          # all different, show next two
          result << friendly_range(event, true)
          result << friendly_range(next_event, true)
        else
          if next_range == next_next_range
            # current is odd one
            result << friendly_range(event, true)
            result << (event.start_at.strftime("%As ") +
              friendly_range(next_event, false))
          elsif range == next_range
            # last is odd one
            result << (event.start_at.strftime("%As ") +
              friendly_range(event, false))
            result << friendly_range(next_next_event, true)
          else
            # middle is odd one
            result << (event.start_at.strftime("%As ") +
              friendly_range(next_event, false))
            result << friendly_range(next_event, true)
          end
        end
      end
    end
=end
    result
  end
  
end
