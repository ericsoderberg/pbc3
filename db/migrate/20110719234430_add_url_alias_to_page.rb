class AddUrlAliasToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :url_aliases, :text
  end

  def self.down
    remove_column :pages, :url_aliases
  end
end
