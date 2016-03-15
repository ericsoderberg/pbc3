class AddHomePageIdToSites < ActiveRecord::Migration
  def change
    add_column :sites, :home_page_id, :integer
  end
end
