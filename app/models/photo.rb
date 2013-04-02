class Photo < ActiveRecord::Base
  belongs_to :page
  has_attached_file :photo, :styles => {
      :normal => '480x',
      :thumb => '50x'
    }
  
  attr_protected :id
    
  validates_presence_of :page
  
  def authorized?(user)
    page.authorized?(user)
  end
  
end
