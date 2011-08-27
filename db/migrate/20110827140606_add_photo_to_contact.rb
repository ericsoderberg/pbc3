class AddPhotoToContact < ActiveRecord::Migration
  def self.up
    add_column :contacts, :bio, :text
    add_column :contacts, :portrait_file_name, :string
    add_column :contacts, :portrait_content_type, :string
    add_column :contacts, :portrait_file_size, :integer
    add_column :contacts, :portrait_updated_at, :datetime
  end

  def self.down
    remove_column :contacts, :portrait_updated_at
    remove_column :contacts, :portrait_file_size
    remove_column :contacts, :portrait_content_type
    remove_column :contacts, :portrait_file_name
    remove_column :contacts, :bio
  end
end
