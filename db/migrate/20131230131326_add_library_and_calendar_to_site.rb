class AddLibraryAndCalendarToSite < ActiveRecord::Migration
  def change
    add_column :sites, :library, :boolean
    add_column :sites, :calendar, :boolean, default: true
  end
end
