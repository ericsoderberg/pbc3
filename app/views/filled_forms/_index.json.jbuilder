form ||= @form
filled_forms = @filled_forms || form.filled_forms_for_user(current_user)

json.formFills filled_forms do |filled_form|
  json.extract!(filled_form, :id, :name, :created_at, :updated_at, :version)
  json.url form_fill_url(form, filled_form)
  json.editPath edit_form_fill_path(form, filled_form)
end
json.count @count
json.filter @filter
json.newPath new_form_fill_path(form)
json.editUrl edit_contents_form_url(form)

json.form do
  json.extract!(form, :name, :version)
end

if @page
  json.page do
    json.extract!(@page, :name)
    json.url friendly_page_path(@page)
  end
end
