require 'test_helper'

class PageTest < ActiveSupport::TestCase
  
  test "normal create" do
    page = Page.new(:name => 'Testing')
    assert page.save
  end
  
  test "no name" do
    page = Page.new
    assert !page.save
  end
  
end
