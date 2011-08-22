class AddEmailAccessToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :allow_for_email_list, :boolean, :default => false
  end

  def self.down
    remove_column :pages, :allow_for_email_list
  end
end
