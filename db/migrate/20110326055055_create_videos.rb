class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.string :caption
      t.string :video_file_name
      t.string :video_content_type
      t.integer :video_file_size
      t.datetime :video_updated_at
      t.integer :page_id

      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
