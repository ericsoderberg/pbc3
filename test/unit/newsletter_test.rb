require 'test_helper'

class NewsletterTest < ActiveSupport::TestCase
  test "normal create" do
    newsletter = Newsletter.new(:name => "News", :published_at => Date.today)
    assert newsletter.save
  end
  
  test "no name" do
    newsletter = Newsletter.new
    assert !newsletter.save
  end
end
