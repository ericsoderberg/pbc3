class AddNoteToInvitation < ActiveRecord::Migration
  def self.up
    add_column :invitations, :note, :text
  end

  def self.down
    remove_column :invitations, :note
  end
end
