class FormField < ActiveRecord::Base
  belongs_to :form
  has_many :form_field_options, :order => 'index ASC',
    :autosave => true, :dependent => :destroy
  has_many :filled_fields, :dependent => :destroy
  
  FIELD = 'field'
  AREA = 'area'
  SINGLE_CHOICE = 'single choice'
  MULTIPLE_CHOICE = 'multiple choice'
  INSTRUCTIONS = 'instructions'
  TYPES = [FIELD, AREA, SINGLE_CHOICE, MULTIPLE_CHOICE, INSTRUCTIONS]
  
  validates :form, :presence => true
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
  
  def copy(source_form_field)
    self.name = source_form_field.name
    self.field_type = source_form_field.field_type
    self.help = source_form_field.help
    source_form_field.form_field_options.each do |source_option|
      new_option = self.form_field_options.build
      new_option.form_field = self
      new_option.copy(source_option)
    end
  end
  
end
