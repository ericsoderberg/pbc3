class AddPaymentMethodsToForm < ActiveRecord::Migration
  def self.up
    add_column :forms, :pay_by_check, :boolean
    add_column :forms, :pay_by_paypal, :boolean
  end

  def self.down
    remove_column :forms, :pay_by_paypal
    remove_column :forms, :pay_by_check
  end
end
