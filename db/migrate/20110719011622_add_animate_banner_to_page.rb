class AddAnimateBannerToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :animate_banner, :boolean, :default => false
  end

  def self.down
    remove_column :pages, :animate_banner
  end
end
