class AddHeroBackgroundToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :hero_background_file_name, :string
    add_column :pages, :hero_background_content_type, :string
    add_column :pages, :hero_background_file_size, :integer
    add_column :pages, :hero_background_update_at, :datetime
  end

  def self.down
    remove_column :pages, :hero_background_update_at
    remove_column :pages, :hero_background_file_size
    remove_column :pages, :hero_background_content_type
    remove_column :pages, :hero_background_file_name
  end
end
