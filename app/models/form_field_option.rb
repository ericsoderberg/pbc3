class FormFieldOption < ActiveRecord::Base
  belongs_to :form_field
  has_many :filled_field_options, :dependent => :destroy
  
  FIXED = 'fixed'
  SINGLE_LINE = 'single line'
  MULTIPLE_LINES = 'multiple lines'
  FIELD = 'field' # TBD
  AREA = 'area'   # TBD
  INSTRUCTIONS = 'instructions'
  OLD_TYPES = [FIXED, FIELD, AREA, INSTRUCTIONS]
  TYPES = [FIXED, SINGLE_LINE, MULTIPLE_LINES, INSTRUCTIONS]
  
  validates :form_field, :presence => true
  validates :name, :presence => true #, :uniqueness => {:scope => :form_field_id}
  validates :option_type, :presence => true,
    :inclusion => { :in => FormFieldOption::TYPES }
    
  def html_name
    name.parameterize.underscore
  end
  
  def sizeable?
    [FIELD, AREA, SINGLE_LINE, MULTIPLE_LINES].include?(option_type)
  end
  
  def copy(source_option)
    self.name = source_option.name
    self.value = source_option.value
    self.option_type = source_option.option_type
    self.help = source_option.help
    self.size = source_option.size
    self.form_field_index = source_option.form_field_index
    self.disabled = source_option.disabled
  end
  
  def selected(filled_field)
    result = false
    
    if filled_field
      
      # newer forms formalize the option selected
      filled_options = filled_field.filled_field_options
      filled_options.each do |filled_option|
        if filled_option.form_field_option == self
          result = true
          break
        end
      end
      
      if filled_options.empty? and filled_field.value
        # older forms only have the value
        unless result
          result = (filled_field.value == self.name)
        end
        unless result
          values = filled_field.value.split(/(?<!\\),/).map{|e| e.gsub(/\\,/, ',')}
          result = values.include?(self.name)
        end
      end
    end
    
    result
  end
  
end
