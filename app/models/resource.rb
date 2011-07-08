class Resource < ActiveRecord::Base
  has_many :reservations, :dependent => :destroy
  has_many :events, :through => :reservations
  acts_as_audited

  TYPES = %w(room equipment)
  
  validates_presence_of :name
  validates :resource_type, :presence => true, :inclusion => {:in => TYPES}
  
  scope :room, where(:resource_type => 'room')
  scope :equipment, where(:resource_type => 'equipment')
  
  def other_events_during(event)
    reservations.between(event.start_at, event.stop_at).
      where('events.id != ?', event.id).map{|reservation| reservation.event}
  end
  
end
