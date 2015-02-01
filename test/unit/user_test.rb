require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  test "normal create" do
    prior_count = User.count
    user = User.new(:name => 'John Doe', :email => 'john.doe@my.com',
      :password => 'johndoe1')
    assert user.save, user.errors.full_messages.join("\n")
    assert_equal prior_count + 1, User.count
  end
  
  test "name splitting" do
    names = [
      ['John Doe', 'John', 'Doe'],
      ['John and Jane Doe', 'John and Jane', 'Doe'],
      ['John A Doe MD', 'John A', 'Doe MD'],
      ['John Smith-Doe', 'John', 'Smith-Doe'],
      ['Rev. John A. Doe', 'Rev. John A.', 'Doe'],
      ['john a. doe jr.', 'john a.', 'doe jr.'],
      ['j. a. doe', 'j. a.', 'doe'],
      ['John van der Doe', 'John', 'van der Doe'],
      ['John', 'John', nil],
      ['J.A. Doe', 'J.A.', 'Doe']
    ]
    names.each_with_index do |name, index|
      user = User.new(:name => name[0], :email => "john.doe-#{index}@my.com",
        :password => 'johndoe1')
      assert user.save, user.errors.full_messages.join("\n")
      assert_equal name[1], user.first_name, 'mismatched first name'
      assert_equal name[2], user.last_name, 'mismatched last name'
    end
  end
  
end
