class CreateVerseRanges < ActiveRecord::Migration
  def self.up
    create_table :verse_ranges do |t|
      t.integer :begin_index
      t.integer :end_index
      t.integer :message_id

      t.timestamps
    end
  end

  def self.down
    drop_table :verse_ranges
  end
end
