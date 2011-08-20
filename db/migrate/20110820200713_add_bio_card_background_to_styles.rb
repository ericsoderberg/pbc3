class AddBioCardBackgroundToStyles < ActiveRecord::Migration
  def self.up
    add_column :styles, :bio_back_file_name, :string
    add_column :styles, :bio_back_content_type, :string
    add_column :styles, :bio_back_file_size, :integer
    add_column :styles, :bio_back_updated_at, :datetime
    add_column :styles, :bio_back_color, :integer, :default => 0
  end

  def self.down
    remove_column :styles, :bio_back_color
    remove_column :styles, :bio_back_updated_at
    remove_column :styles, :bio_back_file_size
    remove_column :styles, :bio_back_content_type
    remove_column :styles, :bio_back_file_name
  end
end
