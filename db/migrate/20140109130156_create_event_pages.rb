class CreateEventPages < ActiveRecord::Migration
  def change
    create_table :event_pages do |t|
      t.integer :page_id
      t.integer :event_id

      t.timestamps
    end
  end
end
