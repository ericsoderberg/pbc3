require 'test_helper'

class FormFieldOptionTest < ActiveSupport::TestCase
  
  test "normal create" do
    option = FormFieldOption.new(:name => 'Testing', :option_type => 'fixed')
    option.form_field = form_fields(:gender)
    assert option.save
  end
  
end
