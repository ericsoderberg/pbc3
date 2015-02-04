require 'test_helper'

class EmailListTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests
  
  def setup
    @model = EmailList.new({name: 'test-list'})
  end
  
end
