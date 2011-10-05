class AddSiteIdToPodcast < ActiveRecord::Migration
  def self.up
    add_column :podcasts, :site_id, :integer
  end

  def self.down
    remove_column :podcasts, :site_id
  end
end
