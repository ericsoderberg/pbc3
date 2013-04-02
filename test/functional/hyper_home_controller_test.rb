require 'test_helper'

class HyperHomeControllerTest < ActionController::TestCase
  
  setup do
    warden
  end
  
  test "should get index" do
    get :index
    assert_response :success
  end

end
