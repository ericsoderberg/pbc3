json.editContents do
  json.partial! 'forms/show'
  json.updateUrl form_path(@form)
  json.authenticityToken form_authenticity_token()
end
