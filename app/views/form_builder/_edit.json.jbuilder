json.editContents do
  json.partial! 'forms/show'
  json.cancelUrl @cancel_url
  json.updateUrl update_contents_form_path(@form)
  json.editContextUrl @edit_context_url
  json.authenticityToken form_authenticity_token()
  if @page
    json.pageId @page.id
  end
  json.message @message
end
