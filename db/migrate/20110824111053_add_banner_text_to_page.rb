class AddBannerTextToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :banner_text, :text
  end

  def self.down
    remove_column :pages, :banner_text
  end
end
