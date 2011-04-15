require 'test_helper'

class AuthorizationsControllerTest < ActionController::TestCase
  setup do
    @authorization = authorizations(:special_private)
    @page = @authorization.page
    sign_in users(:admin)
  end

  test "should get index" do
    get :index, :page_id => @page.url
    assert_redirected_to new_page_authorization_path(:page_id => @page.url)
  end

  test "should get new" do
    get :new, :page_id => @page.url
    assert_response :success
  end

  test "should create authorization" do
    assert_difference('Authorization.count') do
      post :create, :page_id => @page.url, :authorization => @authorization.attributes,
        :user_email => 'admin@localhost'
    end

    assert_redirected_to new_page_authorization_path(:page_id => @page.url)
  end

  test "should show authorization" do
    get :show, :page_id => @page.url, :id => @authorization.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :page_id => @page.url, :id => @authorization.to_param
    assert_response :success
  end

  test "should update authorization" do
    put :update, :page_id => @page.url, :id => @authorization.to_param, :authorization => @authorization.attributes
    assert_redirected_to new_page_authorization_path(:page_id => @page.url)
  end

  test "should destroy authorization" do
    assert_difference('Authorization.count', -1) do
      delete :destroy, :page_id => @page.url, :id => @authorization.to_param
    end

    assert_redirected_to new_page_authorization_path(:page_id => @page.url)
  end
end
