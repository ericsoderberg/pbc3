module FormFieldOptionsHelper
  def form_field_option_text(form_field, option)
    if form_field.monetary?
      if option.value
        option.name + ' $' + option.value.to_s
      else
        '$' + option.name
      end
    else
      option.name
    end
  end
end
