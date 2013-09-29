class Reservation < ActiveRecord::Base
  belongs_to :event
  belongs_to :resource
  
  validates :event, :presence => true
  validates :resource_id, :presence => true,
    :uniqueness => {:scope => :event_id}
  validate :no_overlap
    
  PRE_POST_OPTIONS = [['none', 0], ['1 hour', 60], ['2 hours', 120],
    ['4 hours', 240], ['6 hours', 360], ['8 hours', 480]]
    
  def no_overlap
    overlapping = Reservation.joins(:event, :resource).
      where('resource_id = ? AND event_id != ? AND ' +
        'events.start_at < ? AND events.stop_at > ?',
        self.resource_id, self.event_id,
        self.event.stop_at, self.event.start_at).first
    if overlapping
      self.errors.add(:resource_id, "overlapping usage of " +
        "#{overlapping.resource.name} by #{overlapping.event.name} on " +
        "#{overlapping.event.start_at.simple_date}")
    end
  end
  
  def self.reserve(referenceEvent, resources, update_replicas=false, options={})
    Reservation.transaction do
      events = (update_replicas ? referenceEvent.peers : [referenceEvent])
      events.each do |event|
        # remove existing resources that aren't specified
        event.reservations.each do |reservation|
          next if resources.include?(reservation.resource)
          reservation.destroy!
        end
        # add new ones that we don't have yet
        resources.each do |resource|
          reservation = event.reservations.where('resource_id = ?', resource.id).first
          unless reservation
            reservation = Reservation.new(:event_id => event.id,
              :resource_id => resource.id)
          end
          if options and options[resource.id.to_s]
            reservation.pre_time = options[resource.id.to_s]['pre_time'].to_i
            reservation.post_time = options[resource.id.to_s]['post_time'].to_i
          end
          reservation.save!
        end
      end
    end
  end
  
  def self.between(start, stop)
    # TODO: need to account for pre_time and post_time !!!
    includes(:event).where("events.stop_at > ? AND events.start_at < ?", start, stop).
      references(:event)
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
