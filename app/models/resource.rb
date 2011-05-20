class Resource < ActiveRecord::Base
  has_many :reservations, :dependent => :destroy
  has_many :events, :through => :reservations
  acts_as_audited
  
  validates_presence_of :name
end
