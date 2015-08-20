class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :file_file_name
      t.string :file_content_type
      t.integer :file_file_size
      t.datetime :file_updated_at
      t.string :url
      t.string :kind
      t.text :description
      t.datetime :date
      t.integer :updated_by

      t.timestamps null: false
    end
  end
end
