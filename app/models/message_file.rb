class MessageFile < ActiveRecord::Base
  belongs_to :message
    
  has_attached_file :file,
    :path => ":rails_root/public/system/message_files/:id/:filename",
    :url => "/system/message_files/:id/:filename"
  
  attr_protected :id
  
  validates_presence_of :message
  before_validation :fix_content_type
  
  def audio?
    file.content_type =~ /^audio/
  end
  
  def video?
    file.content_type =~ /^video/
  end
  
  def image?
    file.content_type =~ /^image/
  end
  
  private
  
  # http://www.kensodev.com/2011/04/24/set-the-correct-content-type-when-using-paperclip/
  def fix_content_type
    if (self.file_content_type == 'application/octet-stream')
      type = MIME::Types.type_for(self.file_file_name)
      if (type.kind_of?(Array))
        video = type.select{|t| t.to_s =~ /^video/}
        if video.length > 0
          type = video[0]
        else
          type = type.first
        end
      end
      self.file_content_type = type.to_s
    end
  end
  
end
