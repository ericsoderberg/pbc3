require 'test_helper'

class FilledFormsControllerTest < ActionController::TestCase
  setup do
    @filled_form = filled_forms(:generic_release)
    @form = @filled_form.form
    sign_in users(:admin)
  end

  test "should get index" do
    get :index, :form_id => @form.id
    assert_response :success
    assert_not_nil assigns(:filled_forms)
  end

  test "should get new" do
    get :new, :form_id => @form.id
    assert_response :success
  end

  test "should create filled_form" do
    fields = {}
    @form.form_fields.each{|f| fields[f.id] = {:value => 'test'}}
    assert_difference('FilledForm.count') do
      post :create, :form_id => @form.id, :filled_fields => fields,
        :email_address_confirmation => ''
      #assert false, assigns(:filled_form).errors.full_messages.join("\n")
    end

    assert_redirected_to form_fills_path(assigns(:form))
  end

  test "should show filled_form" do
    get :show, :form_id => @form.id, :id => @filled_form.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :form_id => @form.id, :id => @filled_form.to_param
    assert_response :success
  end

  test "should update filled_form" do
    fields = {}
    @form.form_fields.each{|f| fields[f.id] = {:value => 'test'}}
    put :update, :form_id => @form.id, :id => @filled_form.to_param,
      :filled_fields => fields
    #assert_response :success
    assert_redirected_to edit_form_fill_path(assigns(:form), assigns(:filled_form))
  end

  test "should destroy filled_form" do
    assert_difference('FilledForm.count', -1) do
      delete :destroy, :form_id => @form.id, :id => @filled_form.to_param
    end

    assert_redirected_to new_form_fill_url(assigns(:form))
  end
end
