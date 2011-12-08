class AddDateToVideos < ActiveRecord::Migration
  def self.up
    add_column :videos, :date, :datetime
  end

  def self.down
    remove_column :videos, :date
  end
end
