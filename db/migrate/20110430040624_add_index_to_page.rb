class AddIndexToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :index, :integer
  end

  def self.down
    remove_column :pages, :index
  end
end
