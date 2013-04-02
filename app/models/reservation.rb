class Reservation < ActiveRecord::Base
  belongs_to :event
  belongs_to :resource
  
  attr_protected :id
  
  validates :event, :presence => true
  validates :resource_id, :presence => true,
    :uniqueness => {:scope => :event_id}
    
  PRE_POST_OPTIONS = [['none', 0], ['1 hour', 60], ['2 hours', 120],
    ['4 hours', 240], ['6 hours', 360], ['8 hours', 480]]
  
  def self.reserve(event, resources, update_replicas=false, options={})
    # remove existing resources that aren't specified
    event.reservations.each do |reservation|
      next if resources.include?(reservation.resource)
      event.reservations.delete(reservation)
    end
    # add new ones that we don't have yet
    resources.each do |resource|
      reservation = event.reservations.where('resource_id = ?', resource.id).first
      unless reservation
        reservation = 
          event.reservations.create(:event_id => event.id, :resource_id => resource.id)
      end
      if options and options[resource.id.to_s]
        reservation.pre_time = options[resource.id.to_s]['pre_time'].to_i
        reservation.post_time = options[resource.id.to_s]['post_time'].to_i
        reservation.save
      end
    end
    update_replicas ? event.update_with_replicas : true
  end
  
  def self.between(start, stop)
    # TODO: need to account for pre_time and post_time !!!
    includes(:event).where("events.stop_at > ? AND events.start_at < ?", start, stop)
  end
  
  def copy(for_event)
    reservation = Reservation.new
    reservation.resource = self.resource
    reservation.event = for_event
    reservation.pre_time = self.pre_time
    reservation.post_time = self.post_time
    reservation
  end
  
end
