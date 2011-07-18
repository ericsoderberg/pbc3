class AddPortraitToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :bio, :text
    add_column :users, :portrait_file_name, :string
    add_column :users, :portrait_content_type, :string
    add_column :users, :portrait_file_size, :integer
    add_column :users, :portrait_updated_at, :datetime
    rename_column :users, :avatar_update_at, :avatar_updated_at
  end

  def self.down
    rename_column :users, :avatar_updated_at, :avatar_update_at
    remove_column :users, :portrait_updated_at
    remove_column :users, :portrait_file_size
    remove_column :users, :portrait_content_type
    remove_column :users, :portrait_file_name
    remove_column :users, :bio
  end
end
