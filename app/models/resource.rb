class Resource < ActiveRecord::Base
  has_many :reservations, :dependent => :destroy
  has_many :events, -> { order('start_at DESC') }, :through => :reservations
  
  TYPES = %w(room equipment)
  
  validates_presence_of :name
  validates :resource_type, :presence => true, :inclusion => {:in => TYPES}
  
  scope :rooms, where(:resource_type => 'room')
  scope :equipment, where(:resource_type => 'equipment')
  
  def other_events_during(event)
    reservations.includes(:event).between(event.start_at, event.stop_at).
      where('event_id != ?', event.id).references(:event).
      map{|reservation| reservation.event}
  end
  
end
