require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  
  setup do
    # needed to work around devise problem
    @request.env['warden'] = TestWarden.new(@controller)
  end
  
  test "should get index" do
    get :index
    assert_response :success
  end

end
