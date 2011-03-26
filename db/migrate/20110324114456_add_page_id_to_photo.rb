class AddPageIdToPhoto < ActiveRecord::Migration
  def self.up
    add_column :photos, :page_id, :integer
  end

  def self.down
    remove_column :photos, :page_id
  end
end
