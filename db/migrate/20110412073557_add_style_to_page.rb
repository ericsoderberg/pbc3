class AddStyleToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :style_id, :integer
  end

  def self.down
    remove_column :pages, :style_id
  end
end
