filled_form ||= @filled_form
json.extract!(filled_form, :id, :name, :created_at, :updated_at)
json.filledFields filled_form.filled_fields do |filled_field|
  json.extract!(filled_field, :form_field_id, :value)
  json.filledFieldOptions filled_field.filled_field_options do |filled_option|
    json.extract!(filled_option, :form_field_option_id, :value)
  end
end
json.url form_fill_url(filled_form.form, filled_form)
json.editUrl edit_form_fill_url(filled_form.form, filled_form)
