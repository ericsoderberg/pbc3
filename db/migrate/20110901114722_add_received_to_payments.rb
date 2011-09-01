class AddReceivedToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :received_amount, :integer
    add_column :payments, :received_at, :datetime
    add_column :payments, :received_by, :integer
    add_column :payments, :received_notes, :text
    add_column :payments, :notes, :text
    add_column :payments, :sent_at, :datetime
  end

  def self.down
    remove_column :payments, :sent_at
    remove_column :payments, :notes
    remove_column :payments, :received_notes
    remove_column :payments, :received_by
    remove_column :payments, :received_at
    remove_column :payments, :received_amount
  end
end
