class AddAnyUserToPage < ActiveRecord::Migration
  def change
    add_column :pages, :any_user, :boolean
  end
end
