class FormField < ActiveRecord::Base
  belongs_to :form
  has_many :form_field_options, :order => 'index ASC'
  
  FIELD = 'field'
  AREA = 'area'
  SINGLE_CHOICE = 'single choice'
  MULTIPLE_CHOICE = 'multiple choice'
  INSTRUCTIONS = 'instructions'
  TYPES = [FIELD, AREA, SINGLE_CHOICE, MULTIPLE_CHOICE, INSTRUCTIONS]
  
  validates :name, :presence => true, :uniqueness => {:scope => :form_id}
  validates :field_type, :presence => true,
    :inclusion => { :in => FormField::TYPES }
  
  def has_options?
    [SINGLE_CHOICE, MULTIPLE_CHOICE].include?(field_type)
  end
  
  def sizeable?
    [FIELD, AREA].include?(field_type)
  end
  
  def html_name
    name.parameterize.underscore
  end
  
end
