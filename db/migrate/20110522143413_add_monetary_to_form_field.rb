class AddMonetaryToFormField < ActiveRecord::Migration
  def self.up
    add_column :form_fields, :monetary, :boolean
  end

  def self.down
    remove_column :form_fields, :monetary
  end
end
