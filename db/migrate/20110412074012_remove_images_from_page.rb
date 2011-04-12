class RemoveImagesFromPage < ActiveRecord::Migration
  def self.up
    remove_column :pages, :page_banner_id
    remove_column :pages, :hero_background_file_name
    remove_column :pages, :hero_background_content_type
    remove_column :pages, :hero_background_file_size
    remove_column :pages, :hero_background_update_at
    remove_column :pages, :feature_image_file_name
    remove_column :pages, :feature_image_content_type
    remove_column :pages, :feature_image_file_size
    remove_column :pages, :feature_image_updated_at
  end

  def self.down
    add_column :pages, :feature_image_updated_at, :datetime
    add_column :pages, :feature_image_file_size, :integer
    add_column :pages, :feature_image_content_type, :string
    add_column :pages, :feature_image_file_name, :string
    add_column :pages, :hero_background_update_at, :datetime
    add_column :pages, :hero_background_file_size, :integer
    add_column :pages, :hero_background_content_type, :string
    add_column :pages, :hero_background_file_name, :string
    add_column :pages, :page_banner_id, :integer
  end
end
