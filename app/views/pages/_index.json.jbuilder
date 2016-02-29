json.pages @pages do |page|
  json.extract!(page, :id, :name)
  json.url friendly_page_url(page)
  json.path friendly_page_path(page)
end
json.count @count
json.filter @filter
json.newUrl new_page_url()
