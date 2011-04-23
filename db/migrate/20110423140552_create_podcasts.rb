class CreatePodcasts < ActiveRecord::Migration
  def self.up
    create_table :podcasts do |t|
      t.string :title
      t.string :subtitle
      t.text :summary
      t.text :description
      t.integer :user_id
      t.string :category
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.integer :page_id

      t.timestamps
    end
  end

  def self.down
    drop_table :podcasts
  end
end
