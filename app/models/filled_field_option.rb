class FilledFieldOption < ActiveRecord::Base
  belongs_to :filled_field
  belongs_to :form_field_option
  
  def text_value
    if form_field_option.form_field.monetary?
      if form_field_option.value
        form_field_option.name + ' $' + value.to_s
      else
        '$' + value.to_s
      end
    else
      value
    end
  end
end
