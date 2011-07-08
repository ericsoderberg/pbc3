class AddTypeToResources < ActiveRecord::Migration
  def self.up
    add_column :resources, :resource_type, :string, :default => 'room'
  end

  def self.down
    remove_column :resources, :resource_type
  end
end
