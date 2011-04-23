require 'test_helper'

class PodcastTest < ActiveSupport::TestCase
  
  test "normal create" do
    podcast = Podcast.new()
    podcast.page = pages(:private)
    podcast.owner = users(:admin)
    assert podcast.save
  end
  
  test "no page or user" do
    podcast = Podcast.new
    assert !podcast.save
  end
  
end
