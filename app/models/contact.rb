class Contact < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  
  validates_presence_of :user, :page
end
