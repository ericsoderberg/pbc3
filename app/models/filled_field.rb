class FilledField < ActiveRecord::Base
  belongs_to :filled_form
  belongs_to :form_field
  has_many :filled_field_options, -> {
    includes(:form_field_option) },
    :autosave => true, :dependent => :destroy
  
  validates :filled_form, :presence => true
  validates :form_field_id, :presence => true,
    :uniqueness => {:scope => :filled_form_id}
  validate :within_limit
  
  def within_limit
    if form_field and form_field.limited?
      if form_field.has_options?
        if form_field.limit < options_selected_count
          errors.add(form_field.name, "too many options selected")
        end
      elsif form_field.limited?
        if form_field.remaining < value.to_i
          errors.add(form_field.name, "not enough remaining")
        end
      end
    end
  end
  
  def text_value
    case form_field.field_type
      when FormField::FIELD, FormField::SINGLE_LINE, FormField::MULTIPLE_LINES
        value
      when FormField::SINGLE_CHOICE
        if not filled_field_options.empty?
          filled_field_options.first.text_value
        elsif value and not value.empty?
          value
        end
      when FormField::MULTIPLE_CHOICE
        if not filled_field_options.empty?
          filled_field_options.map{|o| o.text_value}.join(', ')
        elsif value and not value.empty?
          value
        end
      when FormField::COUNT
        if form_field.value and form_field.value.to_i > 0
          value + ' x ' + form_field.value
        else
          value
        end
    end
  end
  
  def options_selected_count
    result = 0
    filled_field_options.each{|o| result += 1 if o.form_field_option.selected(self) }
    result
  end
  
  def payable_amount
    case form_field.field_type
      when FormField::FIELD, FormField::SINGLE_LINE
        value.to_money
      when FormField::SINGLE_CHOICE
        if not filled_field_options.empty?
          filled_field_options.first.value.to_money
        elsif value and not value.empty?
          value.to_money
        else
          0.to_money
        end
      when FormField::MULTIPLE_CHOICE
        if not filled_field_options.empty?
          filled_field_options.map{|o| o.value.to_money}.inject(:+)
        elsif value and not value.empty?
          value.split(',').map{|v| v.to_money}.inject(:+)
        else
          0.to_money
        end
      when FormField::COUNT
        (value.to_i * form_field.value.to_i).to_money
      else
        0.to_money
    end
  end
  
end
