require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  setup do
    @user = users(:generic)
    sign_in users(:admin)
  end
  
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @user.id
    assert_response :success
  end

end
