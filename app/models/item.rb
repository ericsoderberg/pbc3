class Item < ActiveRecord::Base
  has_many :page_elements, as: :element, :dependent => :destroy
  belongs_to :page
  has_attached_file :file,
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
  belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by'

  before_save :set_kind

  def set_kind
    logger.info "!!! Item url: #{self.url} file_name: #{self.file_file_name}"
    path = self.file_file_name || self.url
    # determine what type it is based on what we see in the URL
    if path =~ /vimeo|youtube|\.mp4|\.mpeg/i
      self.kind = 'video'
    elsif path =~ /\.mp3|\.wav/i
      self.kind = 'audio'
    elsif path =~ /\.jpg|\.jpeg|\.png|\.gif/i
      self.kind = 'image'
    elsif path =~ /\.doc|\.txt/i
      self.kind = 'document'
    else
      self.kind = 'unknown'
    end
    logger.info "!!! Item set_kind #{path} set to #{self.kind}"
  end

end
