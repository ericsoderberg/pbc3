class DropUrlNameFromPages < ActiveRecord::Migration
  def self.up
    remove_column :pages, :url_name
  end

  def self.down
    add_column :pages, :url_name, :string
  end
end
