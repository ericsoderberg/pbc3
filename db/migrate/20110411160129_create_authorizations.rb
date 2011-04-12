class CreateAuthorizations < ActiveRecord::Migration
  def self.up
    create_table :authorizations do |t|
      t.integer :page_id
      t.integer :user_id
      t.integer :group_id
      t.boolean :administrator

      t.timestamps
    end
  end

  def self.down
    drop_table :authorizations
  end
end
