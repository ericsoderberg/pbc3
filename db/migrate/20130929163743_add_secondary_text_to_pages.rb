class AddSecondaryTextToPages < ActiveRecord::Migration
  def change
    add_column :pages, :secondary_text, :text
  end
end
