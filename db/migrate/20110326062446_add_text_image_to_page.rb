class AddTextImageToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :text_image_file_name, :string
    add_column :pages, :text_image_content_type, :string
    add_column :pages, :text_image_file_size, :integer
    add_column :pages, :text_image_updated_at, :datetime
  end

  def self.down
    remove_column :pages, :text_image_updated_at
    remove_column :pages, :text_image_file_size
    remove_column :pages, :text_image_content_type
    remove_column :pages, :text_image_file_name
  end
end
