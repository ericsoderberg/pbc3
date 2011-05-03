class CreateFormFields < ActiveRecord::Migration
  def self.up
    create_table :form_fields do |t|
      t.integer :form_id
      t.integer :index
      t.string :name
      t.string :field_type # 'type' is reserved for rails STI
      t.text :help
      t.string :size

      t.timestamps
    end
  end

  def self.down
    drop_table :form_fields
  end
end
