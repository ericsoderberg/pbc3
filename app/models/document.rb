class Document < ActiveRecord::Base
  belongs_to :page
  has_attached_file :file
  acts_as_audited
  
  validates_presence_of :name, :page
  
  searchable do
    text :name, :default_boost => 2
  end
  
end
