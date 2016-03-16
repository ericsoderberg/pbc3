json.libraries @libraries do |library|
  json.extract!(library, :id, :name)
  json.messagesPath library_messages_path(library)
  # json.url library_url(library)
  # json.editUrl edit_library_url(library)
end
json.count @count
json.filter @filter
json.newUrl new_library_url()
