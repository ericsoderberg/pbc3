class Document < ActiveRecord::Base
  belongs_to :page
  has_attached_file :file,
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
  belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by'
  
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
