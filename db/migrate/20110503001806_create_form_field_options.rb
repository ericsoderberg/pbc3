class CreateFormFieldOptions < ActiveRecord::Migration
  def self.up
    create_table :form_field_options do |t|
      t.integer :form_field_id
      t.integer :index
      t.string :name
      t.string :option_type # 'type' is reserved for rails STI
      t.text :help
      t.string :size

      t.timestamps
    end
  end

  def self.down
    drop_table :form_field_options
  end
end
