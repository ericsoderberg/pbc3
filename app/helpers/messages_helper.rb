module MessagesHelper
  def friendly_message_path (library, message)
    if library == @site.library
      message_path(message)
    else
      library_message_path(library, message)
    end
  end
end
