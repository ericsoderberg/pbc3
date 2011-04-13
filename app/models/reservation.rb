class Reservation < ActiveRecord::Base
  belongs_to :event
  belongs_to :resource
  
  def self.reserve(event, resources)
    # remove existing resources that aren't specified
    event.reservations.each do |reservation|
      next if resources.include?(reservation.resource)
      reservation.destroy
    end
    # add new ones that we don't have yet
    resources.each do |resource|
      next if event.resources.include?(resource)
      event.reservations.create(:event_id => event.id, :resource_id => resource.id)
    end
  end
  
end
