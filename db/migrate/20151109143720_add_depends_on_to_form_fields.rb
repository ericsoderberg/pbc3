class AddDependsOnToFormFields < ActiveRecord::Migration
  def change
    add_column :form_fields, :depends_on_id, :integer
  end
end
