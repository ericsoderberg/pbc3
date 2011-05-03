class FormFieldOption < ActiveRecord::Base
  belongs_to :form_field
  
  FIXED = 'fixed'
  FIELD = 'field'
  AREA = 'area'
  INSTRUCTIONS = 'instructions'
  TYPES = [FIXED, FIELD, AREA, INSTRUCTIONS]
  
  validates :name, :presence => true,
    :uniqueness => {:scope => :form_field_id}
  validates :option_type, :presence => true,
    :inclusion => { :in => FormFieldOption::TYPES }
    
  def html_name
    name.parameterize.underscore
  end
  
end
