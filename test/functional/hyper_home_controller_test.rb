require 'test_helper'

class HyperHomeControllerTest < ActionController::TestCase
  
  setup do
    # needed to work around devise problem
    @request.env['warden'] = TestWarden.new(@controller)
  end
  
  test "should get index" do
    get :index
    assert_response :success
  end

end
