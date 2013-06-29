class AddVimeoIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :vimeo_id, :string
  end
end
