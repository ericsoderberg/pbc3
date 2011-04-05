require 'test_helper'

class PageBannersControllerTest < ActionController::TestCase
  setup do
    @page_banner = page_banners(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:page_banners)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create page_banner" do
    assert_difference('PageBanner.count') do
      post :create, :page_banner => @page_banner.attributes
    end

    assert_redirected_to page_banner_path(assigns(:page_banner))
  end

  test "should show page_banner" do
    get :show, :id => @page_banner.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @page_banner.to_param
    assert_response :success
  end

  test "should update page_banner" do
    put :update, :id => @page_banner.to_param, :page_banner => @page_banner.attributes
    assert_redirected_to page_banner_path(assigns(:page_banner))
  end

  test "should destroy page_banner" do
    assert_difference('PageBanner.count', -1) do
      delete :destroy, :id => @page_banner.to_param
    end

    assert_redirected_to page_banners_path
  end
end
