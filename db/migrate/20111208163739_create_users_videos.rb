class CreateUsersVideos < ActiveRecord::Migration
  def self.up
    create_table :users_videos do |t|
      t.integer :user_id
      t.integer :video_id

      t.timestamps
    end
  end

  def self.down
    drop_table :users_videos
  end
end
