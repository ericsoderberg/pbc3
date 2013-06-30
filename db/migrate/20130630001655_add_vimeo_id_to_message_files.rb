class AddVimeoIdToMessageFiles < ActiveRecord::Migration
  def change
    add_column :message_files, :vimeo_id, :string
    add_column :message_files, :youtube_id, :string
  end
end
