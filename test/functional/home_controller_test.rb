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
  
  test "should get private" do
    get :private, :page_id => pages(:private).to_param
    assert_response :success
  end

end
