class Group < ActiveRecord::Base
  belongs_to :page
  validates_presence_of :page_id
  
  def name
    page.name
  end
  
end
