class MessageFile < ActiveRecord::Base
  belongs_to :message
  has_attached_file :file
  
  validates_presence_of :message
  
  def audio?
    file.content_type =~ /^audio/
  end
end
