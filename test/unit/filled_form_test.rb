require 'test_helper'

class FilledFormTest < ActiveSupport::TestCase
  
  test "normal create" do
    form = FilledForm.new(:name => 'Testing')
    form.form = forms(:release)
    form.user = users(:generic)
    assert form.save
  end
  
  test "no form" do
    form = FilledForm.new
    assert !form.save
  end
  
end
