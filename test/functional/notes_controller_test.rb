require 'test_helper'

class NotesControllerTest < ActionController::TestCase
  setup do
    @note = notes(:note1)
    @page = @note.page
    sign_in users(:admin)
  end

=begin
  test "should get index" do
    get :index, :page_id => @page.url
    assert_response :success
    assert_not_nil assigns(:notes)
  end

  test "should get new" do
    get :new, :page_id => @page.url
    assert_response :success
  end

  test "should create note" do
    assert_difference('Note.count') do
      post :create, :page_id => @page.url, :note => @note.attributes
    end

    assert_redirected_to note_path(assigns(:note))
  end

  test "should show note" do
    get :show, :page_id => @page.url, :id => @note.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :page_id => @page.url, :id => @note.to_param
    assert_response :success
  end

  test "should update note" do
    put :update, :page_id => @page.url, :id => @note.to_param, :note => @note.attributes
    assert_redirected_to note_path(assigns(:note))
  end

  test "should destroy note" do
    assert_difference('Note.count', -1) do
      delete :destroy, :page_id => @page.url, :id => @note.to_param
    end

    assert_redirected_to notes_path
  end
=end
end
