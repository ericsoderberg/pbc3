require 'test_helper'

class ReservationsControllerTest < ActionController::TestCase
  
  setup do
    @reservation = reservations(:single_room)
    @event = @reservation.event
    @page = @event.page
    sign_in users(:admin)
  end

  test "should show reservations" do
    get :show, :page_id => @page.url, :event_id => @event.id
    assert_response :success
    assert_not_nil assigns(:resources)
  end
  
  test "should update reservation" do
    put :update, :page_id => @page.url, :event_id => @event.id,
      :resources => Resource.all.map{|r| r.id}
    assert_redirected_to edit_page_event_path(:page_id => @page.url, :id => @event.id)
  end

end
