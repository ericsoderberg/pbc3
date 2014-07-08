class AddHeroTextBackgroundToStyles < ActiveRecord::Migration
  def change
    add_column :styles, :hero_text_background_overlay, :boolean, default: true
  end
end
