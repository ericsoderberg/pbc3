class DeletePageBanner < ActiveRecord::Migration
  def self.up
    drop_table :page_banners
  end

  def self.down
  end
end
