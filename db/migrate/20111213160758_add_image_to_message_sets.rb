class AddImageToMessageSets < ActiveRecord::Migration
  def self.up
    add_column :message_sets, :image_file_name, :string
    add_column :message_sets, :image_content_type, :string
    add_column :message_sets, :image_file_size, :integer
    add_column :message_sets, :image_updated_at, :datetime
  end

  def self.down
    remove_column :message_sets, :image_updated_at
    remove_column :message_sets, :image_file_size
    remove_column :message_sets, :image_content_type
    remove_column :message_sets, :image_file_name
  end
end
