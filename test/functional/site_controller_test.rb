require 'test_helper'

class SiteControllerTest < ActionController::TestCase
  setup do
    @site = sites(:site)
    sign_in users(:admin)
  end
  
  test "should get new" do
    get :new
    assert_redirected_to root_path
  end

  test "should create site" do
    post :create, :site => @site.attributes
    assert_redirected_to root_path
  end

  test "should get edit" do
    get :edit, :id => @site.to_param
    assert_response :success
  end

  test "should update site" do
    put :update, :id => @site.to_param, :site => @site.attributes
    assert_redirected_to root_path
  end
  
end
