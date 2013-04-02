class Document < ActiveRecord::Base
  belongs_to :page
  has_attached_file :file
  audited
  
  attr_protected :id
  
  validates_presence_of :name, :page
  
  searchable do
    text :name, :default_boost => 2
  end
  
  def authorized?(user)
    page.authorized?(user)
  end
  
  def searchable?(user)
    page.searchable?(user)
  end
  
end
