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
  
  test "possible pages" do
    event = events(:single)
    assert event.possible_pages.count == Page.count
  end
  
  test "replicate" do
    event = events(:single)
    dates = [Date.today + 1.week]
    event.replicate(dates)
    assert event.replicas.count == 1
    copy = event.replicas.first
    assert copy.name == event.name
    assert copy.page == event.page
    assert copy.featured? == event.featured?
  end
  
end
