require 'test_helper'

class ConversationsControllerTest < ActionController::TestCase
  setup do
    @conversation = conversations(:chat)
    @page = @conversation.page
    sign_in users(:admin)
  end

  test "should get new" do
    get :new, :page_id => @page.url
    assert_response :success
  end

  test "should create conversation" do
    assert_difference('Conversation.count') do
      post :create, :page_id => @page.url, :conversation => @conversation.attributes
    end

    assert_redirected_to friendly_page_path(@page)
  end

  test "should get edit" do
    get :edit, :page_id => @page.url, :id => @conversation.to_param
    assert_response :success
  end

  test "should update conversation" do
    put :update, :page_id => @page.url, :id => @conversation.to_param, :conversation => @conversation.attributes
    assert_redirected_to friendly_page_path(@page)
  end

  test "should destroy conversation" do
    assert_difference('Conversation.count', -1) do
      delete :destroy, :page_id => @page.url, :id => @conversation.to_param
    end

    assert_redirected_to friendly_page_path(@page)
  end
end
