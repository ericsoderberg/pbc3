class CreateFilledForms < ActiveRecord::Migration
  def self.up
    create_table :filled_forms do |t|
      t.integer :form_id
      t.integer :user_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :filled_forms
  end
end
