class AddPaymentsToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :check_address, :text
    add_column :sites, :online_bank_vendor, :text
    add_column :sites, :paypal_business, :string
  end

  def self.down
    remove_column :sites, :paypal_business
    remove_column :sites, :online_bank_vendor
    remove_column :sites, :check_address
  end
end
