class CreatePageElements < ActiveRecord::Migration
  def change
    create_table :page_elements do |t|
      t.references :page, index: true, null: false
      t.references :element, polymorphic: true, index: true
      t.integer :index
      t.boolean :published, default: true

      t.timestamps null: false
    end
    add_foreign_key :page_elements, :pages
  end
end
