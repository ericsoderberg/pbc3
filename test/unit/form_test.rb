require 'test_helper'

class FormTest < ActiveSupport::TestCase
  
  test "normal create" do
    form = Form.new(:name => 'Testing')
    form.page = pages(:private)
    assert form.save
  end
  
  test "no name" do
    form = Form.new
    assert !form.save
  end
  
end
