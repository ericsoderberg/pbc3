require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  setup do
    @photo = photos(:empty)
    @page = @photo.page
    sign_in users(:admin)
  end

  test "should get index" do
    get :index, :page_id => @page.url
    assert_redirected_to new_page_photo_path(:page_id => @page.url)
  end

  test "should get new" do
    get :new, :page_id => @page.url
    assert_response :success
  end

  test "should create photo" do
    assert_difference('Photo.count') do
      post :create, :page_id => @page.url, :photo => @photo.attributes
    end

    assert_redirected_to new_page_photo_path(:page_id => @page.url)
  end

  test "should show photo" do
    get :show, :page_id => @page.url, :id => @photo.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :page_id => @page.url, :id => @photo.to_param
    assert_response :success
  end

  test "should update photo" do
    put :update, :page_id => @page.url, :id => @photo.to_param, :photo => @photo.attributes
    assert_redirected_to new_page_photo_path(:page_id => @page.url)
  end

  test "should destroy photo" do
    assert_difference('Photo.count', -1) do
      delete :destroy, :page_id => @page.url, :id => @photo.to_param
    end

    assert_redirected_to new_page_photo_path(:page_id => @page.url)
  end
end
