class AddUrlNameToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :url_name, :string
  end

  def self.down
    remove_column :pages, :url_name
  end
end
