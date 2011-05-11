require 'test_helper'

class EventTest < ActiveSupport::TestCase
  
  test "normal create" do
    prior_count = Event.count
    event = Event.new(:name => 'Testing',
      :start_at => Time.zone.now + 1.day,
      :stop_at => Time.zone.now + 1.day + 1.hour)
    event.page = pages(:private)
    assert event.save, event.errors.full_messages.join("\n")
    assert_equal prior_count + 1, Event.count
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
    prior_count = Event.count
    dates = [Date.today + 1.month]
    assert event.replicate(dates)
    assert_equal prior_count + 1, Event.count,
      event.errors.full_messages.join("\n")
    assert_equal 1, event.replicas.count
    copy = event.replicas.first
    assert_equal event.name, copy.name
    assert_equal event.page, copy.page
    assert_equal event.featured?, copy.featured?
    assert_equal event.reservations.count, copy.reservations.count
  end
  
  test "update master name" do
    # update master and ensure replicas pick it up
    event = events(:recurring)
    assert event.replicas.count > 0
    new_name = 'Update Test'
    event.update_attributes({:name => new_name})
    assert_equal new_name, event.name
    event.replicas.each do |replica|
      assert_equal new_name, replica.name
    end
  end
  
  test "add master reservation" do
    # update master and ensure replicas pick it up
    event = events(:recurring)
    assert event.replicas.count > 0
    assert_equal 0, event.reservations.count
    resource = resources(:projector)
    event.reservations.build({:resource => resource})
    assert event.save
    assert_equal 1, event.reservations.count
    event.replicas.each do |replica|
      assert_equal 1, replica.reservations.count
    end
  end
  
  test "replicate replica" do
    event = events(:replica)
    prior_count = Event.count
    dates = [Date.today + 1.month]
    event.replicate(dates)
    assert_equal prior_count, Event.count
  end
  
  test "replicate to same day" do
    event = events(:single)
    prior_count = Event.count
    event.replicate([event.start_at.to_date])
    assert_equal prior_count, Event.count
  end
  
end
