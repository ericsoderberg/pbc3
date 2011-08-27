class AddPublishedAtToAudios < ActiveRecord::Migration
  def self.up
    add_column :audios, :date, :datetime
  end

  def self.down
    remove_column :audios, :date
  end
end
