class Note < ActiveRecord::Base
  belongs_to :page
  validates_presence_of :page_id
  
  validates_presence_of :text
end
