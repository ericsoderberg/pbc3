class AddEmailToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :email, :string
  end

  def self.down
    remove_column :sites, :email
  end
end
