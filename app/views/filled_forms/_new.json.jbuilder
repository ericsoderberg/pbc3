filled_form ||= @filled_form
form = filled_form.form
json.form do
  json.extract!(form, :id, :name, :submit_label)
  json.formSections form.form_sections do |form_section|
    json.extract!(form_section, :id, :name)
    json.fields form_section.form_fields do |form_field|
      filled_field = filled_form.filled_field(form_field)
      json.formField do
        json.extract!(form_field, :id, :name,
          :field_type, :help, :required, :monetary,
          :value, :limit)
        json.formFieldOptions form_field.form_field_options do |form_field_option|
          json.formFieldOption do
            json.extract!(form_field_option, :id, :name, :form_field_index,
              :option_type, :help, :disabled, :value)
          end
          if filled_field
            filled_field_option = filled_field.filled_field_option(form_field_option)
            if filled_field_option
              json.filledFieldOption do
                json.extract!(filled_field_option, :value)
              end
            end
          end
        end
      end
      if filled_field
        json.filledField do
          json.extract!(filled_field, :value)
        end
      end
    end
  end
  if @edit_actions
    json.edit_actions do
      json.array! @edit_actions, :label, :url
    end
  end
end
