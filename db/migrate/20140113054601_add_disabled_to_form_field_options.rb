class AddDisabledToFormFieldOptions < ActiveRecord::Migration
  def change
    add_column :form_field_options, :disabled, :boolean, default: false
  end
end
