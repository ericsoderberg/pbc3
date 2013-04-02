class EventMessage < ActiveRecord::Base
  belongs_to :event
  belongs_to :message
  
  attr_protected :id
  
  validates_presence_of :event, :message
end
