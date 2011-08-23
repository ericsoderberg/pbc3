require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @comment = comments(:chatter)
    @conversation = @comment.conversation
    @page = @conversation.page
    sign_in users(:admin)
  end

  test "should create comment" do
    assert_difference('Comment.count') do
      post :create, :page_id => @page.url, :conversation_id => @conversation.id, :comment => @comment.attributes
    end

    assert_response :success
  end

  test "should update comment" do
    put :update, :page_id => @page.url, :conversation_id => @conversation.id, :id => @comment.to_param, :comment => @comment.attributes
    assert_response :success
  end

  test "should destroy comment" do
    assert_difference('Comment.count', -1) do
      delete :destroy, :page_id => @page.url, :conversation_id => @conversation.id, :id => @comment.to_param
    end

    assert_response :success
  end

end
