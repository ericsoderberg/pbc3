class Item < ActiveRecord::Base
  has_many :page_elements, as: :element, :dependent => :destroy
  has_many :pages, :through => :page_elements, :class_name => 'Page',
    :source => :page
  has_attached_file :file,
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
  belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by'

  before_save :set_kind

  def set_kind
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
  end

end
