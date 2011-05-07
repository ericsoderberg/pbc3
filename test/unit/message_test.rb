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
  
end
