class CreateFormSections < ActiveRecord::Migration
  def change
    create_table :form_sections do |t|
      t.integer :form_id
      t.integer :form_index
      t.string :name

      t.timestamps
    end
    add_column :form_fields, :form_section_id, :integer
  end
end
