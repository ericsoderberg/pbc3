json.editContents do
  json.partial! 'pages/show'
  json.addMenuActions @add_menu_actions
  json.updateContentsOrderUrl update_contents_order_page_path(@page)
  json.authenticityToken form_authenticity_token()
  json.editContextUrl edit_page_url(@page)
end
