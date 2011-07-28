class AddAspectOrderToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :aspect_order, :string
  end

  def self.down
    remove_column :pages, :aspect_order
  end
end
