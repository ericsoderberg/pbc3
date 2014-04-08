class FormField < ActiveRecord::Base
  belongs_to :form
  belongs_to :form_section
  has_many :form_field_options, -> { order('form_field_index ASC') },
    :autosave => true, :dependent => :destroy
  has_many :filled_fields, :dependent => :destroy
  
  FIELD = 'field'
  AREA = 'area'
  SINGLE_LINE = 'single line'
  MULTIPLE_LINES = 'multiple lines'
  SINGLE_CHOICE = 'single choice'
  MULTIPLE_CHOICE = 'multiple choice'
  COUNT = 'count'
  INSTRUCTIONS = 'instructions'
  OLD_TYPES = [FIELD, AREA, SINGLE_CHOICE, MULTIPLE_CHOICE, COUNT, INSTRUCTIONS]
  TYPES = [SINGLE_LINE, MULTIPLE_LINES, SINGLE_CHOICE, MULTIPLE_CHOICE, COUNT, INSTRUCTIONS]
  
  validates :form, :presence => true
  # would like to require a field to be in a form section but we can't do that while there are older forms around
  validates :name, :presence => true #, :uniqueness => {:scope => :form_id}
  validates :field_type, :presence => true,
    :inclusion => { :in => FormField::TYPES }
  
  scope :valued,
    -> { where("form_fields.field_type != '#{INSTRUCTIONS}'") }
  
  def has_options?
    [SINGLE_CHOICE, MULTIPLE_CHOICE].include?(field_type)
  end
  
  def sizeable?
    [SINGLE_LINE, MULTIPLE_LINES, FIELD, AREA, COUNT].include?(field_type)
  end
  
  def limitable?
    MULTIPLE_CHOICE == field_type or COUNT == field_type
  end
  
  def limited?
    limit and limit > 0
  end
  
  def promptable?
    INSTRUCTIONS != field_type
  end
  
  def has_value?
    [COUNT].include?(field_type)
  end
  
  def prompt?
    prompt and not prompt.empty?
  end
  
  def html_name
    name.parameterize.underscore
  end
  
  def remaining
    result = nil
    if limited?
      result = limit
      filled_fields.each do |filled_field|
        result -= filled_field.value.to_i
      end
    end
    result
  end
  
  def copy(source_form_field)
    self.name = source_form_field.name
    self.value = source_form_field.value
    self.field_type = source_form_field.field_type
    self.help = source_form_field.help
    self.prompt = source_form_field.prompt
    self.required = source_form_field.required
    self.limit = source_form_field.limit
    self.monetary = source_form_field.monetary
    self.dense = source_form_field.dense
    self.size = source_form_field.size
    self.form_index = source_form_field.form_index
    source_form_field.form_field_options.each do |source_option|
      new_option = self.form_field_options.build
      new_option.form_field = self
      new_option.copy(source_option)
    end
  end
  
  def migrate
    self.field_type = SINGLE_LINE if FIELD == self.field_type
    self.field_type = MULTIPLE_LINES if AREA == self.field_type
  end
  
end
