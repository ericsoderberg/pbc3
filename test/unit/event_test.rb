require 'test_helper'

class EventTest < ActiveSupport::TestCase
  
  test "normal create" do
    event = Event.new(:name => 'Testing',
      :start_at => Time.zone.now + 1.day,
      :stop_at => Time.zone.now + 1.day + 1.hour)
    event.page = pages(:private)
    assert event.save
  end
  
  test "no page or times" do
    event = Event.new
    assert !event.save
  end
  
  test "stop before start" do
    event = Event.new(:name => 'Testing',
      :start_at => Time.zone.now + 1.day + 1.hour,
      :stop_at => Time.zone.now + 1.day)
    event.page = pages(:private)
    assert !event.save
  end
  
end
