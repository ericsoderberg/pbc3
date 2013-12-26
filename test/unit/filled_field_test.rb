require 'test_helper'

class FilledFieldTest < ActiveSupport::TestCase
  
  test "normal create" do
    field = FilledField.new(:value => 'large')
    field.filled_form = filled_forms(:generic_release)
    field.form_field = form_fields(:size)
    assert field.save, field.errors.full_messages.join("\n")
  end
  
  test "no form" do
    field = FilledField.new
    assert !field.save
  end
  
end
