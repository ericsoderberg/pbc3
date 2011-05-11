require 'test_helper'

class ReservationTest < ActiveSupport::TestCase
  
  test "normal create" do
    prior_count = Reservation.count
    event = events(:single)
    resource = resources(:projector)
    reservation = Reservation.new
    reservation.event = event
    reservation.resource = resource
    assert reservation.save, reservation.errors.full_messages.join("\n")
    assert_equal prior_count + 1, Reservation.count
  end
  
  test "duplicate" do
    prior_count = Reservation.count
    source_reservation = reservations(:single_room)
    reservation = Reservation.new
    reservation.event = source_reservation.event
    reservation.resource = source_reservation.resource
    assert !reservation.save
    assert_equal prior_count, Reservation.count
  end
  
  test "copy" do
    prior_count = Reservation.count
    source_reservation = reservations(:single_room)
    event = events(:replica)
    reservation = source_reservation.copy(event)
    assert reservation.save
    assert_equal prior_count + 1, Reservation.count
    assert_equal source_reservation.resource, reservation.resource
  end
  
end
