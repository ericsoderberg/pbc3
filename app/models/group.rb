class Group < ActiveRecord::Base
  belongs_to :page
  
  def name
    page.name
  end
  
end
