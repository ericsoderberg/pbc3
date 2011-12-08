class AddDetailsToAudios < ActiveRecord::Migration
  def self.up
    add_column :audios, :verses, :string
    add_column :audios, :author, :string
    add_column :audios, :event_id, :integer
    add_column :audios, :description, :text
  end

  def self.down
    remove_column :audios, :description
    remove_column :audios, :event_id
    remove_column :audios, :author
    remove_column :audios, :verses
  end
end
