require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  setup do
    @page = pages(:public)
    sign_in users(:admin)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create page" do
    assert_difference('Page.count') do
      post :create, :page => {:name => 'Test'}
    end

    assert_redirected_to edit_page_path(assigns(:page))
  end
  
  test "should create sub page" do
    @parent = pages(:communities)
    assert_difference('Page.count') do
      post :create, :page => {:name => 'Test', :parent_id => @parent.id}
      assert_equal @parent, assigns(:page).parent
      @parent.reload
      assert @parent.children.include?(assigns(:page))
    end

    assert_redirected_to edit_page_path(assigns(:page))
  end

  test "should show page" do
    get :show, :id => @page.to_param
    assert_response :success
  end
  
  test "should show page alias" do
    get :show, :id => @page.url_aliases.split.first
    assert_redirected_to friendly_page_path(assigns(:page))
  end

  test "should get edit" do
    get :edit, :id => @page.to_param
    assert_response :success
  end
  
  test "should get edit for parent" do
    @parent = pages(:communities)
    get :edit_for_parent, :id => @page.to_param, :parent_id => @parent.id
    assert_response :success
  end
  
  test "should get search possible parents" do
    xhr :get, :search_possible_parents, :id => @page.to_param,
      :q => 'P', :p => '1', :s => '1', :format => :js
    assert_response :success
  end
  
  test "should get search" do
    xhr :get, :search, :q => 'P', :p => '1', :s => '1', :format => :js
    assert_response :success
  end

  test "should update page" do
    put :update, :id => @page.to_param, :page => @page.attributes,
      :sub_order => @page.id.to_s
    assert_redirected_to edit_page_path(assigns(:page))
  end

  test "should destroy page" do
    assert_difference('Page.count', -1) do
      delete :destroy, :id => @page.to_param
    end

    assert_redirected_to pages_path
  end
end
