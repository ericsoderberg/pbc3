class Document < ActiveRecord::Base
  has_many :page_elements, as: :element
  belongs_to :page
  has_attached_file :file,
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
  belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by'

  validates_presence_of :name, :page

  include Searchable
  search_on :name

  def authorized?(user)
    page.authorized?(user)
  end

  def searchable?(user)
    page.searchable?(user)
  end

end
