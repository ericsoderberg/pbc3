class AddMailmanOwnerToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :mailman_owner, :string
  end

  def self.down
    remove_column :sites, :mailman_owner
  end
end
