class Video < ActiveRecord::Base
  belongs_to :page
  has_attached_file :video
  has_attached_file :video2
  has_many :users_videos, :dependent => :destroy, :class_name => 'UsersVideos'
  has_many :users, :through => :users_videos, :source => :user
  
  validates_presence_of :page
  
  def authorized?(user)
    page.authorized?(user)
  end
  
end
