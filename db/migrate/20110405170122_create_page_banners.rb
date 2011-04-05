class CreatePageBanners < ActiveRecord::Migration
  def self.up
    create_table :page_banners do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :page_banners
  end
end
