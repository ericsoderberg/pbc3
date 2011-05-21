class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.string :email
      t.string :key
      t.integer :event_id
      t.string :response
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
