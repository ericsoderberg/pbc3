class DropGroup < ActiveRecord::Migration
  def self.up
    remove_column :authorizations, :group_id
    drop_table :groups
  end

  def self.down
    create_table :groups do |t|
      t.integer :page_id
      t.timestamps
    end
    add_column :authorizations, :group_id, :integer
  end
end
