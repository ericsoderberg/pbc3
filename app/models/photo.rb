class Photo < ActiveRecord::Base
  has_many :page_elements, as: :element
  belongs_to :page
  has_attached_file :photo, :styles => {
      :normal => '480x',
      :thumb => '50x'
    },
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
    
  validates_presence_of :page
  
  def authorized?(user)
    page.authorized?(user)
  end
  
end
