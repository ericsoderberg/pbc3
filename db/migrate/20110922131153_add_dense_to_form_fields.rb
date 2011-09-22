class AddDenseToFormFields < ActiveRecord::Migration
  def self.up
    add_column :form_fields, :dense, :boolean, :default => false
  end

  def self.down
    remove_column :form_fields, :dense
  end
end
