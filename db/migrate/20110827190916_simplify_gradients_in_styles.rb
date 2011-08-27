class SimplifyGradientsInStyles < ActiveRecord::Migration
  def self.up
    rename_column :styles, :gradient_upper_color, :feature_color
    remove_column :styles, :gradient_lower_color
  end

  def self.down
    rename_column :styles, :feature_color, :gradient_upper_color
    add_column :styles, :gradient_lower_color, :string
  end
end
