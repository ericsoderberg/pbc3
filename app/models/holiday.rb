class Holiday < ActiveRecord::Base
  validates :name, :presence => true
  validates :date, :presence => true, :uniqueness => true
  
  attr_protected :id
end
