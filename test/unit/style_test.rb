require 'test_helper'

class StyleTest < ActiveSupport::TestCase
  
  test "normal create" do
    style = Style.new(:name => 'Test')
    assert style.save
  end
  
  test "no name" do
    style = Style.new
    assert !style.save
  end
  
end
