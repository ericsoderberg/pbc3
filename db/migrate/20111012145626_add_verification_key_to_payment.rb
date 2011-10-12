class AddVerificationKeyToPayment < ActiveRecord::Migration
  def self.up
    add_column :payments, :verification_key, :string
  end

  def self.down
    remove_column :payments, :verification_key
  end
end
