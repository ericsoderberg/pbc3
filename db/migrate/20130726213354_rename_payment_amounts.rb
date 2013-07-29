class RenamePaymentAmounts < ActiveRecord::Migration
  def change
    rename_column :payments, :amount, :amount_cents
    rename_column :payments, :received_amount, :received_amount_cents
    change_column_default :payments, :amount_cents, 0
  end
end
