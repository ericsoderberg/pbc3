class Document < ActiveRecord::Base
  belongs_to :page
  has_attached_file :file
  
  validates_presence_of :name, :page
end
