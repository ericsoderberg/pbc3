class AddPageIdToNote < ActiveRecord::Migration
  def self.up
    add_column :notes, :page_id, :integer
  end

  def self.down
    remove_column :notes, :page_id
  end
end
