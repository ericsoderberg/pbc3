require 'test_helper'

class PodcastsControllerTest < ActionController::TestCase
  setup do
    @podcast = podcasts(:public)
    @page = @podcast.page
    @sub_page = pages(:sub_public)
    sign_in users(:admin)
  end

  test "should get new" do
    get :new, :page_id => @sub_page.url
    assert_response :success
  end

  test "should create podcast" do
    assert_difference('Podcast.count') do
      post :create, :page_id => @sub_page.url, :podcast => @podcast.attributes,
        :user_email => 'admin@localhost'
    end

    assert_redirected_to friendly_page_path(@sub_page)
  end

  test "should show podcast" do
    get :show, :page_id => @page.url, :format => 'rss'
    assert_response :success
  end

  test "should get edit" do
    get :edit, :page_id => @page.url
    assert_response :success
  end

  test "should update podcast" do
    put :update, :page_id => @page.url, :podcast => @podcast.attributes
    assert_redirected_to friendly_page_path(@page)
  end

  test "should destroy podcast" do
    assert_difference('Podcast.count', -1) do
      delete :destroy, :page_id => @page.url
    end

    assert_redirected_to friendly_page_path(@page)
  end
end
