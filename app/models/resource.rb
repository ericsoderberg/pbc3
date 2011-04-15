class Resource < ActiveRecord::Base
  has_many :reservations
  has_many :events, :through => :reservations
  
  validates_presence_of :name
end
