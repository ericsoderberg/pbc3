json.app do
  json.site do
    json.extract!(@site, :address, :phone, :copyright)
  end
  json.rootPath root_path
  json.logoUrl @site.wordmark.url
  json.menuActions @app_menu_actions
  json.requestPath request.path
end
