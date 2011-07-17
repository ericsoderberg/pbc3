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
  
  test "valid parents" do
    parent = pages(:blog)
    %w(post).each do |type|
      parent.reload
      page = Page.new(:name => "Test #{parent.name} #{type}",
        :page_type => type)
      page.parent = parent
      assert page.save, page.errors.full_messages.join("\n")
    end
    parent = pages(:public)
    %w(leaf blog main landing).each do |type|
      parent.reload
      page = Page.new(:name => "Test #{parent.name} #{type}",
        :page_type => type)
      page.parent = parent
      assert page.save, page.errors.full_messages.join("\n")
    end
    parent = pages(:communities)
    %w(blog main landing).each do |type|
      parent.reload
      page = Page.new(:name => "Test #{parent.name} #{type}",
        :page_type => type)
      page.parent = parent
      assert page.save, page.errors.full_messages.join("\n")
    end
  end
  
  test "invalid parents" do
    parent = pages(:post)
    %w(landing main blog leaf post).each do |type|
      page = Page.new(:name => 'Test', :page_type => type)
      page.parent = parent
      assert !page.save,
        "able to create a #{type} page in a #{parent.page_type} page"
    end
    parent = pages(:blog)
    %w(landing main blog leaf).each do |type|
      page = Page.new(:name => 'Test', :page_type => type)
      page.parent = parent
      assert !page.save,
        "able to create a #{type} page in a #{parent.page_type} page"
    end
    parent = pages(:public)
    %w(post).each do |type|
      page = Page.new(:name => 'Test', :page_type => type)
      page.parent = parent
      assert !page.save,
        "able to create a #{type} page in a #{parent.page_type} page"
    end
    parent = pages(:communities)
    %w(post).each do |type| # leaf will be automatically changed to main
      page = Page.new(:name => 'Test', :page_type => type)
      page.parent = parent
      assert !page.save,
        "able to create a #{type} page in a #{parent.page_type} page"
    end
  end
  
end
