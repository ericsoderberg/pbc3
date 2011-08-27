class AddParentFeatureToPages < ActiveRecord::Migration
  def self.up
    rename_column :pages, :featured, :home_feature
    rename_column :pages, :feature_index, :home_feature_index
    add_column :pages, :parent_feature, :boolean, :default => false
    add_column :pages, :parent_feature_index, :integer
  end

  def self.down
    remove_column :pages, :parent_feature_index
    remove_column :pages, :parent_feature
    rename_column :pages, :home_feature_index, :feature_index
    rename_column :pages, :home_feature, :featured
  end
end
