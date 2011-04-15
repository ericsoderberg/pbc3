class Video < ActiveRecord::Base
  belongs_to :page
  has_attached_file :video
  
  validates_presence_of :page
end
