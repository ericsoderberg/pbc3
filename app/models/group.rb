class Group < ActiveRecord::Base
  belongs_to :page
  validates_presence_of :page
  
  def name
    page.name
  end
  
end
