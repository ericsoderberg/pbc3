require 'test_helper'

class PageTest < ActiveSupport::TestCase
  
  test "normal create" do
    page = Page.new(:name => 'Testing', :type => 'main')
    assert page.save, page.errors.full_messages.join("\n")
  end
  
  test "no name" do
    page = Page.new
    assert !page.save
  end
  
  test "reserved name" do
    page = Page.new(:name => 'Resources')
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
