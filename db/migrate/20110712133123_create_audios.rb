class CreateAudios < ActiveRecord::Migration
  def self.up
    create_table :audios do |t|
      t.string :caption
      t.string :audio_file_name
      t.string :audio_content_type
      t.integer :audio_file_size
      t.datetime :audio_updated_at
      t.integer :page_id

      t.timestamps
    end
  end

  def self.down
    drop_table :audios
  end
end
