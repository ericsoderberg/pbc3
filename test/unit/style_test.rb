require 'test_helper'

class StyleTest < ActiveSupport::TestCase
  
  test "normal create" do
    style = Style.new(:name => 'Test', :hero_text_color => '0x000000',
      :gradient_upper_color => '0xcccccc', :gradient_lower_color => '0x999999')
    assert style.save
  end
  
  test "no name" do
    style = Style.new
    assert !style.save
  end
  
end
