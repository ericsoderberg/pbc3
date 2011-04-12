class Group < ActiveRecord::Base
  belongs_to :page
  validates_presence_of :page
  has_many :authorizations
  
  def name
    page.name
  end
  
end
