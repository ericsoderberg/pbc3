class AddSocialLinksToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :facebook_url, :string
    add_column :pages, :twitter_name, :string
  end

  def self.down
    remove_column :pages, :twitter_name
    remove_column :pages, :facebook_url
  end
end
