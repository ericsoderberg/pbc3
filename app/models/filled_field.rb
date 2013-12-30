class FilledField < ActiveRecord::Base
  belongs_to :filled_form
  belongs_to :form_field
  has_many :filled_field_options, -> {
    includes(:form_field_option) },
    :autosave => true, :dependent => :destroy
  
  validates :filled_form, :presence => true
  validates :form_field_id, :presence => true,
    :uniqueness => {:scope => :filled_form_id}
  
  def payable_amount
    case form_field.field_type
      when FormField::FIELD
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
