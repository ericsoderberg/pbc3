class AddSecondFileToVideos < ActiveRecord::Migration
  def self.up
    add_column :videos, :video2_file_name, :string
    add_column :videos, :video2_content_type, :string
    add_column :videos, :video2_file_size, :integer
    add_column :videos, :video2_updated_at, :datetime
  end

  def self.down
    remove_column :videos, :video2_updated_at
    remove_column :videos, :video2_file_size
    remove_column :videos, :video2_content_type
    remove_column :videos, :video2_file_name
  end
end
