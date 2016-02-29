json.partial! 'pages/show'
json.edit do
  json.addMenuActions @add_menu_actions
  json.updateContentsOrderPath update_contents_order_page_path(@page)
  json.authenticityToken form_authenticity_token()
  json.editContextUrl edit_page_url(@page)
  json.cancelUrl friendly_page_url(@page)
  json.cancelPath friendly_page_path(@page)
end
