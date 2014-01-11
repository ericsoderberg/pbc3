class RenameFeaturedNameInEvent < ActiveRecord::Migration
  def change
    rename_column :events, :feature_name, :global_name
  end
end
