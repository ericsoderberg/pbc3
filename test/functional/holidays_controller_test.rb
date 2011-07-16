require 'test_helper'

class HolidaysControllerTest < ActionController::TestCase
  setup do
    @holiday = holidays(:christmas)
    sign_in users(:admin)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:holidays)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create holiday" do
    assert_difference('Holiday.count') do
      post :create, :holiday => {:name => "Today", :date => Date.today}
    end

    assert_redirected_to holidays_path
  end

  test "should get edit" do
    get :edit, :id => @holiday.to_param
    assert_response :success
  end

  test "should update holiday" do
    put :update, :id => @holiday.to_param, :holiday => @holiday.attributes
    assert_redirected_to holidays_path
  end

  test "should destroy holiday" do
    assert_difference('Holiday.count', -1) do
      delete :destroy, :id => @holiday.to_param
    end

    assert_redirected_to holidays_path
  end
end
