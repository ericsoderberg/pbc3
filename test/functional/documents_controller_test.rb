require 'test_helper'

class DocumentsControllerTest < ActionController::TestCase
  setup do
    @document = documents(:guide)
    @page = @document.page
    sign_in users(:admin)
  end

  test "should get index" do
    get :index, :page_id => @page.url
    assert_redirected_to edit_page_document_url(@page, @page.documents.first)
  end

  test "should get new" do
    get :new, :page_id => @page.url
    assert_response :success
  end

  test "should create document" do
    assert_difference('Document.count') do
      post :create, :page_id => @page.url, :document => @document.attributes
    end

    assert_redirected_to new_page_document_path(:page_id => @page.url)
  end

  test "should show document" do
    get :show, :page_id => @page.url, :id => @document.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :page_id => @page.url, :id => @document.to_param
    assert_response :success
  end

  test "should update document" do
    put :update, :page_id => @page.url, :id => @document.to_param, :document => @document.attributes
    assert_redirected_to new_page_document_path(:page_id => @page.url)
  end

  test "should destroy document" do
    assert_difference('Document.count', -1) do
      delete :destroy, :page_id => @page.url, :id => @document.to_param
    end

    assert_redirected_to new_page_document_path(:page_id => @page.url)
  end
end
