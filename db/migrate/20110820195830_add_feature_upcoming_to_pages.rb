class AddFeatureUpcomingToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :feature_upcoming, :boolean, :default => false
  end

  def self.down
    remove_column :pages, :feature_upcoming
  end
end
