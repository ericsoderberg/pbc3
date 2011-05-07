class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :title
      t.string :url
      t.string :verses
      t.datetime :date
      t.integer :author_id
      t.string :dpid
      t.text :description
      t.integer :message_set_id
      t.integer :index
      t.integer :event_id

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
