form ||= @form
filled_form ||= @filled_form
json.partial! 'forms/show'
# json.partial! 'filled_forms/show'
json.edit do
  json.createUrl form_fills_url(@form)
  json.authenticityToken form_authenticity_token()
  if @page
    json.pageId @page.id
  else
    json.cancelPath form_fills_path(form)
  end
  json.message @message
end

# json.url form_fill_url(filled_form.form, filled_form)
# json.editUrl edit_form_fill_url(filled_form.form, filled_form)
