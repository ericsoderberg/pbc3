class AddUrlPrefixToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :url_prefix, :string
  end

  def self.down
    remove_column :pages, :url_prefix
  end
end
