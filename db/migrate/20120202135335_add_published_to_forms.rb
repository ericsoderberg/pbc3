class AddPublishedToForms < ActiveRecord::Migration
  def self.up
    add_column :forms, :published, :boolean
  end

  def self.down
    remove_column :forms, :published
  end
end
