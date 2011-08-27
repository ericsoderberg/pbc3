class AddCaptioToMessageFile < ActiveRecord::Migration
  def self.up
    add_column :message_files, :caption, :string
  end

  def self.down
    remove_column :message_files, :caption
  end
end
