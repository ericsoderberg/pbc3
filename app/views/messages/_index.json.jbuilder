json.messages @messages do |message|
  json.extract!(message, :id, :date, :title, :verses)
  json.author message.author, :name
  json.url message_url(message)
end
json.count @count
json.filter @filter
