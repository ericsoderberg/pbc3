class CreateFilledFieldOptions < ActiveRecord::Migration
  def change
    create_table :filled_field_options do |t|
      t.integer :filled_field_id
      t.integer :form_field_option_id
      t.text    :value

      t.timestamps
    end
  end
end
