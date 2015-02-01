require 'test_helper'

class FormFieldOptionsControllerTest < ActionController::TestCase
  setup do
    @form_field_option = form_field_options(:male)
    @form_field = @form_field_option.form_field
    @form = @form_field.form
    sign_in users(:admin)
  end

  test "should create form_field_option" do
    assert_difference('FormFieldOption.count') do
      post :create, :form_id => @form.id, :field_id => @form_field.id,
        :format => 'js'
    end
    assert_response :success
  end

  test "should show form_field_option" do
    xhr :get, :show, :form_id => @form.id, :field_id => @form_field.id,
      :id => @form_field_option.to_param, :format => 'js'
    assert_response :success
  end

  test "should get edit" do
    xhr :get, :edit, :form_id => @form.id, :field_id => @form_field.id,
      :id => @form_field_option.to_param, :format => 'js'
    assert_response :success
  end

  test "should update form_field_option" do
    put :update, :form_id => @form.id, :field_id => @form_field.id,
      :id => @form_field_option.to_param,
      :form_field_option => @form_field_option.attributes,
      :format => 'js'
    assert_response :success
  end

  test "should destroy form_field_option" do
    assert_difference('FormFieldOption.count', -1) do
      delete :destroy, :form_id => @form.id,
        :field_id => @form_field.id, :id => @form_field_option.to_param,
        :format => 'js'
    end
    assert_response :success
  end
end
