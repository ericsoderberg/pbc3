class CreateEventMessages < ActiveRecord::Migration
  def self.up
    create_table :event_messages do |t|
      t.integer :event_id
      t.integer :message_id

      t.timestamps
    end
  end

  def self.down
    drop_table :event_messages
  end
end
