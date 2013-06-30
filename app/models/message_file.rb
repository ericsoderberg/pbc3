class MessageFile < ActiveRecord::Base
  belongs_to :message
    
  has_attached_file :file,
    :path => ":rails_root/public/system/message_files/:id/:filename",
    :url => "/system/message_files/:id/:filename"
  
  attr_protected :id
  
  validates_presence_of :message
  validate :one_type
  before_validation :fix_content_type
  
  def audio?
    file.content_type =~ /^audio/
  end
  
  def video?
    file.content_type =~ /^video/
  end
  
  def cloud_video?
    (youtube_id and not youtube_id.empty?) or
    (vimeo_id and not vimeo_id.empty?)
  end
  
  def image?
    file.content_type =~ /^image/
  end
  
  def youtube?
    youtube_id and not youtube_id.empty?
  end
  
  def vimeo?
    vimeo_id and not vimeo_id.empty?
  end
  
  private
  
  def one_type
    if (not self.file_file_name and not self.youtube? and not self.vimeo?)
      self.errors.add :file, "At least one file, YouTube ID, or Vimeo ID must be specified"
      return false
    elsif ((self.file_file_name and (self.youtube? or self.vimeo?)) or
      (self.youtube? and self.vimeo?))
      self.errors.add :file, "At most one of file, YouTube ID, and Vimeo ID can be specified"
      return false
    end
    return true
  end
  
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
