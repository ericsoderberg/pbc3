class FormFieldOption < ActiveRecord::Base
  belongs_to :form_field
  
  FIXED = 'fixed'
  FIELD = 'field'
  AREA = 'area'
  INSTRUCTIONS = 'instructions'
  TYPES = [FIXED, FIELD, AREA, INSTRUCTIONS]
  
  validates :form_field, :presence => true
  validates :name, :presence => true,
    :uniqueness => {:scope => :form_field_id}
  validates :option_type, :presence => true,
    :inclusion => { :in => FormFieldOption::TYPES }
    
  def html_name
    name.parameterize.underscore
  end
  
  def sizeable?
    [FIELD, AREA].include?(option_type)
  end
  
end
