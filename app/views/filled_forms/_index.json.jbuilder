form ||= @form
filled_forms = @filled_forms || form.filled_forms_for_user(current_user)

json.filled_forms filled_forms, partial: 'filled_forms/show', as: :filled_form
json.count @count
json.filter @filter
json.newUrl new_form_fill_url(form)
json.editUrl edit_contents_form_path(form)

json.form do
  json.name form.name
end
