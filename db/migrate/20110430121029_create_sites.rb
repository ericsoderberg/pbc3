class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.integer :communities_page_id
      t.integer :about_page_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sites
  end
end
