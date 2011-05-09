require 'test_helper'

class MessageSetsControllerTest < ActionController::TestCase
  setup do
    @message_set = message_sets(:gospels)
    sign_in users(:admin)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:message_sets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create message_set" do
    assert_difference('MessageSet.count') do
      post :create, :message_set => @message_set.attributes
    end

    assert_redirected_to series_path(assigns(:message_set))
  end

  test "should show message_set" do
    get :show, :id => @message_set.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @message_set.to_param
    assert_response :success
  end

  test "should update message_set" do
    put :update, :id => @message_set.to_param, :message_set => @message_set.attributes
    assert_redirected_to series_path(assigns(:message_set))
  end

  test "should destroy message_set" do
    assert_difference('MessageSet.count', -1) do
      delete :destroy, :id => @message_set.to_param
    end

    assert_redirected_to series_index_path
  end
end
