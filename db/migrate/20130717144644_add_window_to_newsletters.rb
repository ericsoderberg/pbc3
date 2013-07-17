class AddWindowToNewsletters < ActiveRecord::Migration
  def change
    add_column :newsletters, :window, :integer, null: false, default: 4
  end
end
