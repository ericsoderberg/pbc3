require 'test_helper'

class SocialControllerTest < ActionController::TestCase
  
  setup do
    @page = pages(:public)
    sign_in users(:admin)
  end
  
  test "should get edit" do
    get :edit, :page_id => @page.url
    assert_response :success
  end

end
