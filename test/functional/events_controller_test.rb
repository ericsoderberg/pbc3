require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup do
    @event = events(:single)
    @page = @event.page
    sign_in users(:admin)
  end

  test "should get index" do
    get :index, :page_id => @page.url
    assert_redirected_to edit_page_event_path(@page, @page.events.first)
  end

  test "should get new" do
    get :new, :page_id => @page.url
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      post :create, :page_id => @page.url, :event => @event.attributes
    end

    assert_redirected_to edit_page_event_path(:page_id => @page.url, :id => assigns(:event).id)
  end

  test "should show event" do
    get :show, :page_id => @page.url, :id => @event.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :page_id => @page.url, :id => @event.to_param
    assert_response :success
  end

  test "should update event" do
    put :update, :page_id => @page.url, :id => @event.to_param, :event => @event.attributes
    assert_redirected_to new_page_event_path(:page_id => @page.url)
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete :destroy, :page_id => @page.url, :id => @event.to_param
    end

    assert_redirected_to new_page_event_path(:page_id => @page.url)
  end
end
