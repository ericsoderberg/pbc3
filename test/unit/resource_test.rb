require 'test_helper'

class ResourceTest < ActiveSupport::TestCase
  
  test "normal create" do
    resource = Resource.new(:name => "Car")
    assert resource.save
  end
  
  test "no name" do
    resource = Resource.new
    assert !resource.save
  end
  
  test "duplicate name" do
    resource = Resource.new(:name => "Room")
    assert resource.save
  end
  
  test "other events during" do
    resource = resources(:room)
    single = events(:single)
    conflicts = resource.other_events_during(single)
    assert_equal 0, conflicts.length
  end
  
end
