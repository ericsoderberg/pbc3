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
  
  test "should get index csv" do
    get :index, :form_id => @form.id, :format => 'csv'
    assert_response :success
    assert_not_nil assigns(:filled_forms)
  end
  
  test "should get index xls" do
    get :index, :form_id => @form.id, :format => 'xls'
    assert_response :success
    assert_not_nil assigns(:filled_forms)
  end

  test "should get new" do
    get :new, :form_id => @form.id
    assert_response :success
  end

  test "should create filled_form" do
    # build reasonable field values
    fields = {}
    @form.form_fields.each do |form_field|
      value = case form_field.field_type
      when FormField::SINGLE_LINE, FormField::MULTIPLE_LINES
        'test'
      when FormField::SINGLE_CHOICE
        form_field.form_field_options.first.id.to_s
      when FormField::MULTIPLE_CHOICE
        [form_field.form_field_options.first.id.to_s]
      when FormField::COUNT
        "2"
      end
      fields[form_field.id.to_s] = {:value => value}
    end
    assert_difference('FilledForm.count') do
      post :create, :form_id => @form.id, :filled_fields => fields,
        :email_address_confirmation => ''
      #assert false, assigns(:filled_form).errors.full_messages.join("\n")
    end

    assert_redirected_to friendly_page_path(assigns(:page))
  end

  test "should show filled_form" do
    get :show, :form_id => @form.id, :id => @filled_form.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :form_id => @form.id, :id => @filled_form.to_param
    assert_response :success
  end
  
  test "should get old edit" do
    filled_form = filled_forms(:old_release)
    form = filled_form.form
    get :edit, :form_id => form.id, :id => filled_form.to_param
    assert_response :success
  end

  test "should update filled_form" do
    fields = {}
    @form.form_fields.each{|f| fields[f.id] = {:value => 'test'}}
    put :update, :form_id => @form.id, :id => @filled_form.to_param,
      :filled_fields => fields
    assert_response :success
    #assert_redirected_to form_fills_path(assigns(:form))
  end

  test "should destroy filled_form" do
    assert_difference('FilledForm.count', -1) do
      delete :destroy, :form_id => @form.id, :id => @filled_form.to_param
    end

    assert_redirected_to edit_form_fill_url(assigns(:form), assigns(:next_filled_form))
  end
end
