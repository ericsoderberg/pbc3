class Group < ActiveRecord::Base
  belongs_to :page
  validates_presence_of :page
  has_many :authorizations
  
  def self.visible(user)
    joins(:page).merge(Page.visible(user))
  end
  
  def name
    page.name
  end
  
end
