class RemoveTextImageFromPage < ActiveRecord::Migration
  def self.up
    remove_column :pages, :text_image_file_name
    remove_column :pages, :text_image_content_type
    remove_column :pages, :text_image_file_size
    remove_column :pages, :text_image_updated_at
  end

  def self.down
  end
end
