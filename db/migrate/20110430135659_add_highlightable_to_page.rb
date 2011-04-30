class AddHighlightableToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :highlightable, :boolean
  end

  def self.down
    remove_column :pages, :highlightable
  end
end
