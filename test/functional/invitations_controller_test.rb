require 'test_helper'

class InvitationsControllerTest < ActionController::TestCase
  setup do
    @invitation = invitations(:generic)
    @event = @invitation.event
    @page = @event.page
    sign_in users(:admin)
  end

  test "should get index" do
    get :index, :page_id => @page.url, :event_id => @event.id
    assert_response :success
    assert_not_nil assigns(:invitations)
  end
  
  test "should update invitation" do
    put :update, :page_id => @page.url, :event_id => @event.id,
      :id => @invitation.to_param, :invitation => @invitation.attributes
    assert_redirected_to friendly_page_url(assigns(:page),
      :invitation_key => assigns(:invitation).key)
  end

  test "should destroy invitation" do
    assert_difference('Invitation.count', -1) do
      delete :destroy, :page_id => @page.url, :event_id => @event.id,
        :id => @invitation.to_param
    end

    assert_redirected_to page_event_invitations_path(assigns(:page),
      assigns(:event))
  end
end
