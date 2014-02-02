require 'test_helper'

class FormSectionTest < ActiveSupport::TestCase
  
  test "normal create" do
    section = FormSection.new(:name => 'Testing')
    section.form = forms(:release)
    assert section.save
  end
  
  test "no form" do
    section = FormSection.new(:name => 'Testing')
    assert !section.save
  end
  
end
