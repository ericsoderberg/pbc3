class AddRoleToContact < ActiveRecord::Migration
  def self.up
    add_column :contacts, :role, :string
  end

  def self.down
    remove_column :contacts, :role
  end
end
