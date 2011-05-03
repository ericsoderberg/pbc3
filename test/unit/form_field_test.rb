require 'test_helper'

class FormFieldTest < ActiveSupport::TestCase
  
  test "normal create" do
    field = FormField.new(:name => 'Testing', :field_type => 'field')
    field.form = forms(:release)
    assert field.save
  end
  
end
