class AddFeatureNameToEvent < ActiveRecord::Migration
  def change
    add_column :events, :feature_name, :string
  end
end
