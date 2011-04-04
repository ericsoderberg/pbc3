class Contact < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  validates_presence_of :user_id
  validates_presence_of :page_id
end
