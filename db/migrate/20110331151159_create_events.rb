class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.datetime :start_at
      t.datetime :stop_at
      t.boolean :all_day
      t.string :location
      t.integer :page_id

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
