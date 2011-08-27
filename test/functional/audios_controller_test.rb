require 'test_helper'

class AudiosControllerTest < ActionController::TestCase
  
  setup do
    @audio = audios(:empty)
    @page = @audio.page
    sign_in users(:admin)
  end

  test "should get index" do
    get :index, :page_id => @page.url
    assert_redirected_to new_page_audio_path(:page_id => @page.url)
  end

  test "should get new" do
    get :new, :page_id => @page.url
    assert_response :success
  end

  test "should create audio" do
    assert_difference('Audio.count') do
      post :create, :page_id => @page.url, :audio => @audio.attributes
    end

    assert_redirected_to new_page_audio_path(:page_id => @page.url)
  end

  test "should show audio" do
    get :show, :page_id => @page.url, :id => @audio.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :page_id => @page.url, :id => @audio.id
    assert_response :success
  end

  test "should update audio" do
    put :update, :page_id => @page.url, :id => @audio.to_param, :audio => @audio.attributes
    assert_redirected_to new_page_audio_path(:page_id => @page.url)
  end

  test "should destroy audio" do
    assert_difference('Audio.count', -1) do
      delete :destroy, :page_id => @page.url, :id => @audio.to_param
    end

    assert_redirected_to new_page_audio_path(:page_id => @page.url)
  end
end
