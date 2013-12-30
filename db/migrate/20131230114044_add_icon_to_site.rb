class AddIconToSite < ActiveRecord::Migration
  def change
    add_column :sites, :icon_file_name, :string
    add_column :sites, :icon_content_type, :string
    add_column :sites, :icon_file_size, :integer
    add_column :sites, :icon_updated_at, :datetime
    add_column :sites, :acronym, :string
  end
end
