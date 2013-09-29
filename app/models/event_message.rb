class EventMessage < ActiveRecord::Base
  belongs_to :event
  belongs_to :message
  
  validates_presence_of :event, :message
end
