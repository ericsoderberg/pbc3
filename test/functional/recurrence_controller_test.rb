require 'test_helper'

class RecurrenceControllerTest < ActionController::TestCase
  
  setup do
    @event = events(:recurring)
    @page = @event.page
    sign_in users(:admin)
  end

  test "should show recurrence" do
    get :show, :page_id => @page.url, :event_id => @event.id
    assert_response :success
    assert_not_nil assigns(:calendar)
  end
  
  test "should update recurrence" do
    put :update, :page_id => @page.url, :event_id => @event.id,
      :days => [@event.start_at.to_date.to_s(:db),
        2.week.from_now.to_date.to_s(:db)]
    assert_redirected_to edit_page_event_path(:page_id => @page.url,
      :id => @event.id)
  end

end
