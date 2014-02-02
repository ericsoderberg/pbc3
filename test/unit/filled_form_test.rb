require 'test_helper'

class FilledFormTest < ActiveSupport::TestCase
  
  test "normal create" do
    filled_form = FilledForm.new(:name => 'Testing')
    filled_form.form = forms(:release)
    filled_form.user = users(:generic)
    filled_field = FilledField.new
    filled_form.filled_fields << filled_field
    filled_field.filled_form = filled_form
    filled_field.form_field = form_fields(:acknowledgement)
    option = FilledFieldOption.new
    filled_field.filled_field_options << option
    option.filled_field = filled_field
    option.form_field_option = form_field_options(:agree)
    assert filled_form.save, filled_form.errors.full_messages.join("\n")
  end
  
  test "no form" do
    form = FilledForm.new
    assert !form.save
  end
  
end
