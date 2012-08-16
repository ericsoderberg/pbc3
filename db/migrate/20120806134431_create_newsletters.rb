class CreateNewsletters < ActiveRecord::Migration
  def self.up
    create_table :newsletters do |t|
      t.string :name
      t.string :email_list
      t.date :published_at
      t.integer :featured_page_id
      t.integer :featured_event_id
      t.text :note
      t.string :sent_to
      t.datetime :sent_at

      t.timestamps
    end
  end

  def self.down
    drop_table :newsletters
  end
end
