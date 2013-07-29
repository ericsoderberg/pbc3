class FormFieldOption < ActiveRecord::Base
  belongs_to :form_field
  
  ###attr_protected :id
  
  FIXED = 'fixed'
  FIELD = 'field' # TBD
  AREA = 'area'   # TBD
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
  
  def copy(source_option)
    self.name = source_option.name
    self.option_type = source_option.option_type
    self.help = source_option.help
  end
end
