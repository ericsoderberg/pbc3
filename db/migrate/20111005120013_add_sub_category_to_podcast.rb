class AddSubCategoryToPodcast < ActiveRecord::Migration
  def self.up
    add_column :podcasts, :sub_category, :string
  end

  def self.down
    remove_column :podcasts, :sub_category
  end
end
