class ChangeDefaultsOnPage < ActiveRecord::Migration
  def self.up
    change_column_default(:pages, :private, false)
    change_column_default(:pages, :featured, false)
  end

  def self.down
  end
end
