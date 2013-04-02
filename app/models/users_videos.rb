class UsersVideos < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  
  attr_protected :id
  
  validates_presence_of :user, :video

end
