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
    dates = [event.start_at.to_date, Date.today + 1.month]
    assert event.replicate(dates)
    assert_equal prior_count + 1, Event.count,
      event.errors.full_messages.join("\n") +
      event.replicas.map{|e| e.errors.full_messages.join("\n")}.join("\n")
    assert_equal 1, event.replicas.count, "mismatched replica count"
    copy = event.replicas.first
    assert_equal event.name, copy.name, "mismatched name"
    assert_equal event.page, copy.page, "mismatched page"
    assert_equal event.featured?, copy.featured?, "mismatched feature"
    assert_equal event.reservations.count, copy.reservations.count,
      "mismatched reservation count"
  end
  
  test "update master name" do
    # update master and ensure replicas pick it up
    event = events(:recurring)
    assert event.replicas.count > 0
    new_name = 'Update Test'
    event.update_with_replicas({:name => new_name})
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
    assert event.update_with_replicas
    assert_equal 1, event.reservations.count
    event.replicas.each do |replica|
      assert_equal 1, replica.reservations.count
    end
  end
  
  test "replicate master" do
    event = events(:recurring)
    prior_count = event.replicas.count
    existing_dates = event.master_and_replicas.map{|e| e.start_at.to_date}
    dates = existing_dates + [Date.today + 6.months]
    event.replicate(dates)
    event.reload
    assert_equal prior_count + 1, event.replicas.count, "mismatched replicas"
    event.replicas.each{|e| assert_equal event, e.master}
  end
  
  test "replicate replica" do
    event = events(:replica)
    prior_count = event.replicas.count
    prior_master_count = event.master.replicas.count
    existing_dates = event.master_and_replicas.map{|e| e.start_at.to_date}
    dates = existing_dates + [Date.today + 6.months]
    event.replicate(dates)
    event.reload
    assert_equal prior_master_count + 1, event.replicas.count
    event.replicas.each{|e| assert_equal event, e.master}
  end
  
  test "replicate to same day" do
    event = events(:single)
    prior_count = Event.count
    event.replicate([event.start_at.to_date])
    assert_equal prior_count, Event.count
  end
  
  test "best non replica" do
    event = events(:single)
    best = event.best_replica(events)
    assert_equal event, best
  end
  
  test "best self replica" do
    event = events(:recurring)
    best = event.best_replica(events)
    assert_equal event, best
  end
  
  test "best other replica" do
    event = events(:ancient_replica)
    best = event.best_replica(Event.all)
    assert_equal events(:recurring), best
  end
  
  test "delete master replica" do
    event = events(:recurring)
    prior_count = event.replicas.count
    existing_dates = event.replicas.map{|e| e.start_at.to_date}
    dates = existing_dates # left off master date
    event.replicate(dates)
    event.reload
    assert_nil event.master
    assert_equal existing_dates.first, event.start_at.to_date
    assert_equal prior_count - 1, event.replicas.count, "mismatched replicas"
    event.replicas.each{|e| assert_equal event, e.master}
  end
  
  test "categorization" do
    categorized = Event.categorize(Event.all)
    assert_equal 2, categorized[:active].count, 'mismatched active'
    assert_equal 1, categorized[:expired].count, 'mismatched expired'
    assert_equal 1, categorized[:ancient].count, 'mismatched ancient'
  end
  
end
