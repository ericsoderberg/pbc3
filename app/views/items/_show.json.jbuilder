item ||= @item
json.extract!(item, :name, :kind, :date, :description)
if item.file.exists?
  json.content_type item.file.content_type
end
json.url (item.file.exists? ? item.file.url : item.url)
