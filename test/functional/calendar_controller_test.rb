require 'test_helper'

class CalendarControllerTest < ActionController::TestCase
  
  setup do
    warden
  end
  
  test "should get month" do
    get :month
    assert_response :success
    assert_not_nil assigns(:events)
    assert_not_nil assigns(:calendar)
  end

  test "should get list" do
    get :list
    assert_response :success
    assert_not_nil assigns(:events)
  end

  test "should get day" do
    get :day
    assert_response :success
  end

end
