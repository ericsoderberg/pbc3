class AddPublishedAtToAudios < ActiveRecord::Migration
  def self.up
    add_column :audios, :published_at, :datetime
  end

  def self.down
    remove_column :audios, :published_at
  end
end
