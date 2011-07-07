require 'test_helper'

class MessageSetTest < ActiveSupport::TestCase
  
  test "between" do
    today = Date.today
    message_sets = MessageSet.between(today - 2.weeks, today + 1.week)
    assert message_sets.count == 1
  end
  
end
