class CreateReservations < ActiveRecord::Migration
  def self.up
    create_table :reservations do |t|
      t.integer :event_id
      t.integer :resource_id

      t.timestamps
    end
  end

  def self.down
    drop_table :reservations
  end
end
