require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  
  test "normal create" do
    contact = Contact.new()
    contact.page = pages(:private)
    contact.user = users(:admin)
    assert contact.save
  end
  
  test "no page or user" do
    contact = Contact.new
    assert !contact.save
  end
  
end
