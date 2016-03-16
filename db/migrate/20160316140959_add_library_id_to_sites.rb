class AddLibraryIdToSites < ActiveRecord::Migration
  def change
    add_column :sites, :library_id, :integer
  end
end
