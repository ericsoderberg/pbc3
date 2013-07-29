class Authorization < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  belongs_to :group
  
  ###attr_protected :id
  
  validates_presence_of :page, :user
end
