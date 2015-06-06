class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.text :text
      t.integer :updated_by

      t.timestamps null: false
    end
  end
end
