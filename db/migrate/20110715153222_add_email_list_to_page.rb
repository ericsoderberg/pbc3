class AddEmailListToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :email_list, :string
  end

  def self.down
    remove_column :pages, :email_list
  end
end
