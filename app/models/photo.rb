class Photo < ActiveRecord::Base
  belongs_to :page
  has_attached_file :photo, :styles => {
      :normal => '400x',
      :thumb => '50x'
    }
    
  validates_presence_of :page
end
