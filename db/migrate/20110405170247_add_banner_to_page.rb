class AddBannerToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :page_banner_id, :integer
  end

  def self.down
    remove_column :pages, :page_banner_id
  end
end
