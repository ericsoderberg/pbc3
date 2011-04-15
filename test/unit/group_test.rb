require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  
  test "normal create" do
    group = Group.new()
    group.page = pages(:private)
    assert group.save
  end
  
  test "no page" do
    group = Group.new
    assert !group.save
  end
  
end
