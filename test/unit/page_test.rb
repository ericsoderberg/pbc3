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
  
  test "duplicate name" do
    page = Page.new(:name => 'Public')
    assert !page.save
  end
  
  test "possible parents" do
    page = pages(:public)
    assert page.possible_parents.length < Page.count
  end
  
  test "includes" do
    page = pages(:public)
    sub_page = pages(:sub_public)
    assert page.includes?(sub_page)
  end
  
end
