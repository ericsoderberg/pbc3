class Video < ActiveRecord::Base
  belongs_to :page
  has_attached_file :video
  has_attached_file :video2
  
  validates_presence_of :page
  
  def authorized?(user)
    page.authorized?(user)
  end
  
end
