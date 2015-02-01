require 'test_helper'

class FormFieldsControllerTest < ActionController::TestCase
  setup do
    @form_field = form_fields(:age)
    @form_section = @form_field.form_section
    @form = @form_field.form
    sign_in users(:admin)
  end

  test "should create form_field" do
    assert_difference('FormField.count') do
      post :create, :form_id => @form.id, :form_section_id => @form_section.id,
        :form_field => {:name => 'Testing', :field_type => 'single line'},
        :format => 'js'
    end
    assert_response :success
  end

  test "should show form_field" do
    xhr :get, :show, :form_id => @form.id, :id => @form_field.to_param,
      :format => 'js'
    assert_response :success
  end

  test "should get edit" do
    xhr :get, :edit, :form_id => @form.id, :id => @form_field.to_param,
      :format => 'js'
    assert_response :success
  end

  test "should update form_field" do
    put :update, :form_id => @form.id, :id => @form_field.to_param,
      :form_field => @form_field.attributes,
      :options => {'1' => {:name => 'Name', :option_type => 'fixed'}},
      :format => 'js'
    assert_response :success
  end

  test "should destroy form_field" do
    assert_difference('FormField.count', -1) do
      delete :destroy, :form_id => @form.id, :id => @form_field.to_param,
        :format => 'js'
    end
    assert_response :success
  end
end
