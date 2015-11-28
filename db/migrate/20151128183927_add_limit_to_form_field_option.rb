class AddLimitToFormFieldOption < ActiveRecord::Migration
  def change
    add_column :form_field_options, :limit, :integer
  end
end
