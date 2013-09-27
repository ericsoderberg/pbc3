class RemoveActsAsAudited < ActiveRecord::Migration
  def self.up
    drop_table :audits
  end

  def self.down
  end
end
