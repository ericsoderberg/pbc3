class Note < ActiveRecord::Base
  belongs_to :page
  audited
  
  attr_protected :id
  
  validates_presence_of :page_id
  validates_presence_of :text, :page
end
