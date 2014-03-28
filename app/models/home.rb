class Home
  
  def self.events
    today = Date.today.beginning_of_day
    Event.featured.between(today, today + 8.weeks).
      order('start_at ASC').select{|e|
        e.authorized?(nil) and not e.page.obscure? and
        (! e.prev || e.prev.start_at < today) and
        e.messages.empty? and
        (e.start_at < (today + 4.weeks) or
        e.page.home_feature?)
      }
  end
  
  def self.next_message
    today = Date.today.beginning_of_day
    Message.between(today, today + 1.week).first;
  end
  
  def self.previous_message
    today = Date.today.end_of_day
    Message.between(today - 2.weeks, today - 1.day).last;
  end
  
end
