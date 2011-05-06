require 'test_helper'

class FilledFieldsControllerTest < ActionController::TestCase
  setup do
    @filled_field = filled_fields(:generic_age)
  end

=begin
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:filled_fields)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create filled_field" do
    assert_difference('FilledField.count') do
      post :create, :filled_field => @filled_field.attributes
    end

    assert_redirected_to filled_field_path(assigns(:filled_field))
  end

  test "should show filled_field" do
    get :show, :id => @filled_field.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @filled_field.to_param
    assert_response :success
  end

  test "should update filled_field" do
    put :update, :id => @filled_field.to_param, :filled_field => @filled_field.attributes
    assert_redirected_to filled_field_path(assigns(:filled_field))
  end

  test "should destroy filled_field" do
    assert_difference('FilledField.count', -1) do
      delete :destroy, :id => @filled_field.to_param
    end

    assert_redirected_to filled_fields_path
  end
=end
end
