class AddChildLayoutToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :child_layout, :string
  end

  def self.down
    remove_column :pages, :child_layout
  end
end
