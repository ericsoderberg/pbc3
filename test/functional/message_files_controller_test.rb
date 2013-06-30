require 'test_helper'

class MessageFilesControllerTest < ActionController::TestCase
  setup do
    @message_file = message_files(:genesis)
    @message = @message_file.message
    sign_in users(:admin)
  end

  test "should get index" do
    get :index, :message_id => @message.url
    assert_response :success
    assert_not_nil assigns(:message_files)
  end

  test "should get new" do
    get :new, :message_id => @message.url
    assert_response :success
  end

  test "should create message_file" do
    attributes = @message_file.attributes.clone
    attributes.delete('id')
    assert_difference('MessageFile.count') do
      post :create, :message_id => @message.url, :message_file => attributes
    end

    assert_redirected_to edit_message_path(assigns(:message))
  end

  test "should show message_file" do
    get :show, :message_id => @message.url, :id => @message_file.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :message_id => @message.url, :id => @message_file.to_param
    assert_response :success
  end

  test "should update message_file" do
    attributes = @message_file.attributes.clone
    attributes.delete('id')
    put :update, :message_id => @message.url, :id => @message_file.to_param, :message_file => attributes
    assert_redirected_to edit_message_path(assigns(:message))
  end

  test "should destroy message_file" do
    assert_difference('MessageFile.count', -1) do
      delete :destroy, :message_id => @message.url, :id => @message_file.to_param
    end

    assert_redirected_to edit_message_path(assigns(:message))
  end
end
