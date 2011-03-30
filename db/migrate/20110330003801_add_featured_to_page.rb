class AddFeaturedToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :featured, :boolean
  end

  def self.down
    remove_column :pages, :featured
  end
end
