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
  
end
