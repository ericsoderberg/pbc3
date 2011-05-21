class AddInvitationMessageToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :invitation_message, :text
  end

  def self.down
    remove_column :events, :invitation_message
  end
end
