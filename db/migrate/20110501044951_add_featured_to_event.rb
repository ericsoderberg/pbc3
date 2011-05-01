class AddFeaturedToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :featured, :boolean
  end

  def self.down
    remove_column :events, :featured
  end
end
