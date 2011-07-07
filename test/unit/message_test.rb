require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  
  test "normal create" do
    message = Message.new(:title => 'Test Message',
      :verses => 'Romans 12:1-10')
    message.author = authors(:prolific)
    assert message.save
    assert message.verse_ranges.count == 1
  end
  
  test "no title" do
    message = Message.new
    assert !message.save
  end
  
  test "between with full sets" do
    today = Date.today
    messages = Message.between_with_full_sets(today - 2.weeks, today + 1.week)
    assert_equal 3, messages.count
  end
  
end
