class AddRenderedFeatureTextToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :rendered_feature_text, :text
  end

  def self.down
    remove_column :pages, :rendered_feature_text
  end
end
