class CreateMessageSets < ActiveRecord::Migration
  def self.up
    create_table :message_sets do |t|
      t.string :title
      t.string :url
      t.text :description
      t.integer :author_id

      t.timestamps
    end
  end

  def self.down
    drop_table :message_sets
  end
end
