require 'test_helper'

class CalendarControllerTest < ActionController::TestCase
  test "should get month" do
    get :month
    assert_response :success
  end

  test "should get list" do
    get :list
    assert_response :success
  end

  test "should get day" do
    get :day
    assert_response :success
  end

end
