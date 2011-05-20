class AddPageTypeToPage < ActiveRecord::Migration
  def self.up
    remove_column :pages, :landing
    add_column :pages, :page_type, :string,
      :default => 'main', :null => false
  end

  def self.down
    add_column :pages, :landing, :boolean, :default => :false
    remove_column :pages, :page_type
  end
end
