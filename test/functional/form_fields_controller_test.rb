require 'test_helper'

class FormFieldsControllerTest < ActionController::TestCase
  setup do
    @form_field = form_fields(:age)
    @form = @form_field.form
    sign_in users(:admin)
  end

  test "should get new" do
    get :new, :form_id => @form.id
    assert_response :success
  end

  test "should create form_field" do
    assert_difference('FormField.count') do
      post :create, :form_id => @form.id,
        :form_field => {:name => 'Testing', :field_type => 'field'}
    end

    assert_redirected_to form_field_path(@form, assigns(:form_field))
  end

  test "should show form_field" do
    get :show, :form_id => @form.id, :id => @form_field.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :form_id => @form.id, :id => @form_field.to_param
    assert_response :success
  end

  test "should update form_field" do
    put :update, :form_id => @form.id, :id => @form_field.to_param,
      :form_field => @form_field.attributes,
      :options => {'1' => {:name => 'Name', :option_type => 'fixed'}}
    assert_redirected_to form_field_path(assigns(:form_field))
  end

  test "should destroy form_field" do
    assert_difference('FormField.count', -1) do
      delete :destroy, :form_id => @form.id, :id => @form_field.to_param
    end

    assert_redirected_to form_fields_path
  end
end
