json.page do
  json.partial! 'pages/show', edit: true
end
json.edit do
  json.addMenuActions @add_menu_actions
  json.updateContentsOrderUrl update_contents_order_page_url(@page)
  json.authenticityToken form_authenticity_token()
  json.editContextUrl edit_page_url(@page)
  json.cancelUrl friendly_page_url(@page)
  json.cancelPath friendly_page_path(@page)
end
