class AddTitleToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :title, :string
    add_column :sites, :subtitle, :string
    add_column :sites, :address, :string
    add_column :sites, :copyright, :string
  end

  def self.down
    remove_column :sites, :copyright
    remove_column :sites, :address
    remove_column :sites, :subtitle
    remove_column :sites, :title
  end
end
