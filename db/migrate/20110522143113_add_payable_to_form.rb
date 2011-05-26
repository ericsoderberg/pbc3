class AddPayableToForm < ActiveRecord::Migration
  def self.up
    add_column :forms, :payable, :boolean
  end

  def self.down
    remove_column :forms, :payable
  end
end
