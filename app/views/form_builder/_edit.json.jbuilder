json.editContents do
  json.partial! 'forms/show'
  json.cancelUrl forms_path()
  json.updateUrl update_contents_form_path(@form)
  json.editContextUrl edit_form_path(@form)
  json.authenticityToken form_authenticity_token()
end
