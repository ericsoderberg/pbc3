require 'test_helper'

class BooksControllerTest < ActionController::TestCase
  setup do
    sign_in users(:generic)
  end
  
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show, :id => 'Genesis'
    assert_response :success
  end

end
