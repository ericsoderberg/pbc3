class AddBannerTextColorToStyle < ActiveRecord::Migration
  def self.up
    add_column :styles, :banner_text_color, :integer, :default => 0
  end

  def self.down
    remove_column :styles, :banner_text_color
  end
end
