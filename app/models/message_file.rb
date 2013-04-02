class MessageFile < ActiveRecord::Base
  belongs_to :message
    
  has_attached_file :file,
    :path => ":rails_root/public/system/message_files/:id/:filename",
    :url => "/system/message_files/:id/:filename"
  
  attr_protected :id
  
  validates_presence_of :message
  
  def audio?
    file.content_type =~ /^audio/
  end
  
  def image?
    file.content_type =~ /^image/
  end
  
end
