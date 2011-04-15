require 'test_helper'

class VideosControllerTest < ActionController::TestCase
  
  setup do
    @video = videos(:empty)
    @page = @video.page
    sign_in users(:admin)
  end

  test "should get index" do
    get :index, :page_id => @page.url
    assert_redirected_to new_page_video_path(:page_id => @page.url)
  end

  test "should get new" do
    get :new, :page_id => @page.url
    assert_response :success
  end

  test "should create video" do
    assert_difference('Video.count') do
      post :create, :page_id => @page.url, :video => @video.attributes
    end

    assert_redirected_to new_page_video_path(:page_id => @page.url)
  end

  test "should show video" do
    get :show, :page_id => @page.url, :id => @video.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :page_id => @page.url, :id => @video.id
    assert_response :success
  end

  test "should update video" do
    put :update, :page_id => @page.url, :id => @video.to_param, :video => @video.attributes
    assert_redirected_to new_page_video_path(:page_id => @page.url)
  end

  test "should destroy video" do
    assert_difference('Video.count', -1) do
      delete :destroy, :page_id => @page.url, :id => @video.to_param
    end

    assert_redirected_to new_page_video_path(:page_id => @page.url)
  end
end
