class AddLayoutToPage < ActiveRecord::Migration
  def self.up
    rename_column :pages, :page_type, :layout
    change_column_default :pages, :layout, 'regular'
    execute "UPDATE pages SET layout = 'regular' WHERE layout IN ('main', 'leaf', 'post')"
    add_column :pages, :obscure, :boolean
  end

  def self.down
    remove_column :pages, :obscure
    rename_column :pages, :layout, :page_type
    change_column_default :pages, :page_type, 'main'
    execute "UPDATE pages SET page_type = 'main' WHERE page_type = 'regular'"
  end
end
