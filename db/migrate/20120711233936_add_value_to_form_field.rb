class AddValueToFormField < ActiveRecord::Migration
  def self.up
    add_column :form_fields, :value, :string
  end

  def self.down
    remove_column :form_fields, :value
  end
end
