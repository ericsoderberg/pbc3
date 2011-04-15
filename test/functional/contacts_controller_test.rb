require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  setup do
    @contact = contacts(:special)
    @page = @contact.page
    sign_in users(:admin)
  end

  test "should get index" do
    get :index, :page_id => @page.url
    assert_redirected_to new_page_contact_path(:page_id => @page.url)
  end

  test "should get new" do
    get :new, :page_id => @page.url
    assert_response :success
  end

  test "should create contact" do
    assert_difference('Contact.count') do
      post :create, :page_id => @page.url, :contact => @contact.attributes,
        :user_email => 'admin@localhost'
    end

    assert_redirected_to new_page_contact_path(:page_id => @page.url)
  end

  test "should show contact" do
    get :show, :page_id => @page.url, :id => @contact.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :page_id => @page.url, :id => @contact.to_param
    assert_response :success
  end

  test "should update contact" do
    put :update, :page_id => @page.url, :id => @contact.to_param, :contact => @contact.attributes
    assert_redirected_to new_page_contact_path(:page_id => @page.url)
  end

  test "should destroy contact" do
    assert_difference('Contact.count', -1) do
      delete :destroy, :page_id => @page.url, :id => @contact.to_param
    end

    assert_redirected_to new_page_contact_path(:page_id => @page.url)
  end
end
