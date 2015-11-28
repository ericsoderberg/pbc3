form ||= @form
json.form do
  json.extract!(form, :id, :name, :submit_label, :many_per_user, :published)
  json.formSections form.form_sections do |form_section|
    json.extract!(form_section, :id, :name, :depends_on_id)
    json.formFields form_section.form_fields do |form_field|
      json.extract!(form_field, :id, :name,
        :field_type, :help, :required, :monetary,
        :value, :limit, :depends_on_id, :unit_value)
      json.formFieldOptions form_field.form_field_options do |form_field_option|
        json.extract!(form_field_option, :id, :name,
          :option_type, :help, :disabled, :value)
      end
    end
  end
  if @edit_actions
    json.edit_actions do
      json.array! @edit_actions, :label, :url
    end
  end
end
