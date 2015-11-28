class AddUnitValueToFormField < ActiveRecord::Migration
  def change
    add_column :form_fields, :unit_value, :string
  end
end
