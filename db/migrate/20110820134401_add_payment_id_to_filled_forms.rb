class AddPaymentIdToFilledForms < ActiveRecord::Migration
  def self.up
    add_column :filled_forms, :payment_id, :integer
  end

  def self.down
    remove_column :filled_forms, :payment_id
  end
end
