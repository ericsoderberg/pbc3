class Contact < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  
  has_attached_file :portrait, :styles => {
      :normal => '400x',
      :thumb => '50x'
    }
  
  validates_presence_of :user, :page
end
