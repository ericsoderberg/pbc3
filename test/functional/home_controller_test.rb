require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  
  setup do
    warden
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
