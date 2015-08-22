json.form do
  json.extract!(@form, :id, :name)
  json.formSections @form.form_sections do |form_section|
    json.extract!(form_section, :id, :name, :form_index)
    json.formFields form_section.form_fields do |form_field|
      json.extract!(form_field, :id, :name, :form_index,
        :field_type, :help, :size, :required, :monetary,
        :dense, :value, :prompt, :limit)
      json.formFieldOptions form_field.form_field_options do |form_field_option|
        json.extract!(form_field_option, :id, :name, :form_field_index,
          :option_type, :help, :size, :disabled, :value)
      end
    end
  end
  if @edit_actions
    json.edit_actions do
      json.array! @edit_actions, :label, :url
    end
  end
end
