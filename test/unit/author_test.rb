require 'test_helper'

class AuthorTest < ActiveSupport::TestCase
  
  test "normal create" do
    author = Author.new(:name => 'Tester')
    assert author.save
  end
  
  test "no name" do
    author = Author.new
    assert !author.save
  end
  
end
