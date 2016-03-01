form ||= @form
filled_form ||= @filled_form
json.partial! 'forms/show'
json.partial! 'filled_forms/show'
json.edit do
  json.updateUrl update_contents_form_url(@form)
  json.authenticityToken form_authenticity_token()
  if @page
    json.pageId @page.id
  else
    json.cancelUrl form_fills_url(form)
  end
  json.message @message
end

# json.url form_fill_url(filled_form.form, filled_form)
# json.editUrl edit_form_fill_url(filled_form.form, filled_form)
