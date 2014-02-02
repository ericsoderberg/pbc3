class AddLimitToFormFields < ActiveRecord::Migration
  def change
    add_column :form_fields, :limit, :integer
  end
end
