class CreateConversations < ActiveRecord::Migration
  def self.up
    create_table :conversations do |t|
      t.text :text
      t.integer :user_id
      t.integer :page_id

      t.timestamps
    end
  end

  def self.down
    drop_table :conversations
  end
end
