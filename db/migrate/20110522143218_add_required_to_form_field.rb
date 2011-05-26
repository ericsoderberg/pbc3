class AddRequiredToFormField < ActiveRecord::Migration
  def self.up
    add_column :form_fields, :required, :boolean
  end

  def self.down
    remove_column :form_fields, :required
  end
end
