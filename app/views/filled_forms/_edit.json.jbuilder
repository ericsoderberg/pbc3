form ||= @form
filled_form ||= @filled_form
json.form do
  json.partial! 'forms/show'
end
json.formFill do
  json.partial! 'filled_forms/show'
end
json.edit do
  json.updateUrl form_fill_url(form, filled_form)
  json.authenticityToken form_authenticity_token()
  json.cancelPath form_fills_path(form)
  json.message @message
end
