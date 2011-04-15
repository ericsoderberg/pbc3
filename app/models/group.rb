class Group < ActiveRecord::Base
  belongs_to :page
  validates_presence_of :page
  has_many :authorizations
  
  scope :visible, lambda { |user|
    joins(:page) & Page.visible(user)
  }
  
  def name
    page.name
  end
  
end
