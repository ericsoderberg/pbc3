class AddDependsOnToFormSections < ActiveRecord::Migration
  def change
    add_column :form_sections, :depends_on_id, :integer
  end
end
