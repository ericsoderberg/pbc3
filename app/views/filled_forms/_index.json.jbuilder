form ||= @form
filled_forms = @filled_forms || form.filled_forms_for_user(current_user)

json.filled_forms filled_forms, partial: 'filled_forms/show', as: :filled_form
json.count @count
json.filter @filter
json.newUrl new_form_fill_url(form)
json.editUrl edit_contents_form_path(form)

json.form do
  json.extract!(form, :name, :version)
end

if @page
  json.page do
    json.extract!(@page, :name)
    json.url friendly_page_path(@page)
  end
end
