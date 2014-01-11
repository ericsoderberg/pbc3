class AddVersionToForm < ActiveRecord::Migration
  def change
    add_column :forms, :version, :integer, :default => 1
    add_column :filled_forms, :version, :integer, :default => 1
  end
end
