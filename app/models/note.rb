class Note < ActiveRecord::Base
  belongs_to :page
  acts_as_audited
  
  validates_presence_of :page_id
  validates_presence_of :text, :page
end
