class AddYouTubeIdToVideos < ActiveRecord::Migration
  def self.up
    add_column :videos, :youtube_id, :string
  end

  def self.down
    remove_column :videos, :youtube_id
  end
end
