require 'test_helper'

class PodcastTest < ActiveSupport::TestCase
  
  test "normal create" do
    podcast = Podcast.new()
    podcast.page = pages(:private)
    podcast.owner = users(:admin)
    podcast.title = podcast.subtitle = podcast.summary = podcast.description =
      podcast.category = "something"
    assert podcast.save
  end
  
  test "no page or user" do
    podcast = Podcast.new
    assert !podcast.save
  end
  
end
