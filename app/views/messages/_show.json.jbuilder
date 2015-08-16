json.message do
  json.extract! @message, :title, :verses, :date, :description
  if @message.image.exists?
    json.imageUrl @message.image.url(:normal)
  end
  if @message.author
    json.author @message.author
  end
  json.files @files do |message_file|
    json.content_type message_file.file.content_type
    json.extract! message_file, :vimeo_id, :youtube_id, :caption, :id
    json.url message_file.file.url
  end
  json.editUrl edit_message_url(@message)
end
if @next_message
  json.nextMessage do
    json.extract! @next_message, :title, :verses, :date
    json.author @next_message.author
    json.url message_url(@next_message)
  end
end
if @previous_message
  json.previousMessage do
    json.extract! @previous_message, :title, :verses, :date
    json.author @previous_message.author
    json.url message_url(@previous_message)
  end
end
