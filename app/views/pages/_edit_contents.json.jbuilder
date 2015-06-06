json.editContents do
  json.partial! 'pages/show'
  json.addMenuActions @add_menu_actions
end
