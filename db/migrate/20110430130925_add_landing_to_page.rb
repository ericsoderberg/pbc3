class AddLandingToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :landing, :boolean
  end

  def self.down
    remove_column :pages, :landing
  end
end
