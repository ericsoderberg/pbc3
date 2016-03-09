json.partial! 'forms/show'
json.edit do
  json.cancelUrl @context_url
  json.updateUrl update_contents_form_url(@form)
  json.editContextUrl @edit_context_url
  json.authenticityToken form_authenticity_token()
  if @page
    json.pageId @page.id
  end
  json.message @message
end
