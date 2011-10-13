class AddVerificationKeyToFilledForm < ActiveRecord::Migration
  def self.up
    add_column :filled_forms, :verification_key, :string
  end

  def self.down
    remove_column :filled_forms, :verification_key
  end
end
