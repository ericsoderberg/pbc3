class AddFeatureIndexToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :feature_index, :integer
  end

  def self.down
    remove_column :pages, :feature_index
  end
end
