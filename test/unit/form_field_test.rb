require 'test_helper'

class FormFieldTest < ActiveSupport::TestCase
  
  test "normal create" do
    field = FormField.new(:name => 'Testing', :field_type => 'single line')
    field.form = forms(:release)
    assert field.save
  end
  
  test "no form" do
    field = FormField.new(:name => 'Testing', :field_type => 'single line')
    assert !field.save
  end
  
end
