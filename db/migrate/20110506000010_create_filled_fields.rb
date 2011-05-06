class CreateFilledFields < ActiveRecord::Migration
  def self.up
    create_table :filled_fields do |t|
      t.integer :filled_form_id
      t.integer :form_field_id
      t.text :value

      t.timestamps
    end
  end

  def self.down
    drop_table :filled_fields
  end
end
