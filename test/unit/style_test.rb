require 'test_helper'

class StyleTest < ActiveSupport::TestCase
  
  test "normal create" do
    style = Style.new(:name => 'Test', :hero_text_color => '0x000000',
      :feature_color => '0xcccccc')
    assert style.save
  end
  
  test "no name" do
    style = Style.new
    assert !style.save
  end
  
end
