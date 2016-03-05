form ||= @form
filled_forms = @filled_forms || form.filled_forms_for_user(current_user)

json.formFills filled_forms do |filled_form|
  json.extract!(filled_form, :id, :name, :created_at, :updated_at, :version)
  json.url form_fill_url(form, filled_form)
  json.editPath edit_form_fill_path(form, filled_form)
end

json.edit do
  json.createUrl form_fills_url(form)
  json.authenticityToken form_authenticity_token()
  json.pageId page.id

  if current_user and current_user.administrator?
    json.indexPath form_fills_path(form)
  end
end
