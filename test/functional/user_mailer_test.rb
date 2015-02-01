require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  
  def test_contact_email
    page = pages(:public)
    contact = page.contacts.first

    # Send the email, then test that it got queued
    email = UserMailer.contact_email(page, contact, 'test message',
      'Tester', 'tester@nowhere').deliver_now
    assert !ActionMailer::Base.deliveries.empty?

    # Test the body of the sent email contains what we expect it to
    assert_equal [contact.user.email], email.to
  end
end
