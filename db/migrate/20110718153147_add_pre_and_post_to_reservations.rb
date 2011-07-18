class AddPreAndPostToReservations < ActiveRecord::Migration
  def self.up
    add_column :reservations, :pre_time, :integer
    add_column :reservations, :post_time, :integer
  end

  def self.down
    remove_column :reservations, :post_time, :integer
    remove_column :reservations, :pre_time, :integer
  end
end
