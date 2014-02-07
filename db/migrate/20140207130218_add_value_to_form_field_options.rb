class AddValueToFormFieldOptions < ActiveRecord::Migration
  def change
    add_column :form_field_options, :value, :integer
  end
end
