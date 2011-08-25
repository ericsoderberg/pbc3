class Audio < ActiveRecord::Base
  belongs_to :page
  has_attached_file :audio
  
  validates_presence_of :page
  
  def authorized?(user)
    page.authorized?(user)
  end
  
end
