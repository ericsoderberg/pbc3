class ChangePrivateDefaultOnPage < ActiveRecord::Migration
  def self.up
    change_column_default(:pages, :private, true)
  end

  def self.down
    change_column_default(:pages, :private, nil)
  end
end
