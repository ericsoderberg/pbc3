class Video < ActiveRecord::Base
  belongs_to :page
  has_attached_file :video,
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
  has_attached_file :video2,
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
  has_many :users_videos, :dependent => :destroy, :class_name => 'UsersVideos'
  has_many :users, :through => :users_videos, :source => :user
  ###audited
  
  ###attr_protected :id
  
  validates_presence_of :page
  
  def authorized?(user)
    page.authorized?(user)
  end
  
end
