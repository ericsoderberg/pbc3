json.messages @messages do |message|
  json.extract!(message, :id, :date, :title, :verses)
  if message.author
    json.author message.author, :name
  end
  json.url message_url(message)
end
json.count @count
json.filter @filter
json.newUrl new_message_url()
