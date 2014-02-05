class AddParentToForms < ActiveRecord::Migration
  def change
    add_column :forms, :parent_id, :integer
    add_column :forms, :authenticated, :boolean, :default => false
    add_column :forms, :many_per_user, :boolean, :default => false
    add_column :filled_forms, :parent_id, :integer
  end
end
