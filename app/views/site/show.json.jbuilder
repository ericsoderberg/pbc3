json.site do
  json.extract!(@site, :address, :phone, :copyright)
  json.logoUrl @site.wordmark.url
  json.menuActions @app_menu_actions
end
