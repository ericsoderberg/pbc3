class AddLibraryToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :library_id, :integer
    add_column :message_sets, :library_id, :integer
  end

  def self.down
    remove_column :messages, :library_id
    remove_column :message_sets, :library_id
  end
end
