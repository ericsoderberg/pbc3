library ||= @library
json.extract!(library, :name)
json.path library_messages_path(library)

nextUpcomingMessage = library.nextUpcomingMessage
if nextUpcomingMessage
  json.nextUpcomingMessage do
    json.extract! nextUpcomingMessage, :title, :verses, :date
    json.author nextUpcomingMessage.author
    json.path friendly_message_path(library, nextUpcomingMessage)
  end
end

mostRecentMessage = library.mostRecentMessage
if mostRecentMessage
  json.mostRecentMessage do
    json.extract! mostRecentMessage, :title, :verses, :date
    json.author mostRecentMessage.author
    json.path friendly_message_path(library, mostRecentMessage)
  end
end
