class Document < ActiveRecord::Base
  belongs_to :page
  has_attached_file :file
  acts_as_audited
  
  validates_presence_of :name, :page
end
