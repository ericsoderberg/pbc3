require 'test_helper'

class AuthorizationTest < ActiveSupport::TestCase
  
  test "normal create" do
    auth = Authorization.new()
    auth.page = pages(:private)
    auth.user = users(:admin)
    assert auth.save
  end
  
  test "no page or user" do
    auth = Authorization.new
    assert !auth.save
  end
  
end
