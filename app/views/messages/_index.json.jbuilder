json.messages @messages do |message|
  json.extract!(message, :id, :date, :title, :verses)
  if message.author
    json.author message.author, :name
  end
  json.path friendly_message_path(@library, message)
end
json.count @count
json.filter @filter
json.newUrl new_library_message_url(@library)
json.editUrl edit_library_url(@library)

json.library do
  json.extract!(@library, :name)
end
