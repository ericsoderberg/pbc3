class AddFullToPageElement < ActiveRecord::Migration
  def change
    add_column :page_elements, :full, :boolean
    add_column :page_elements, :color, :string
  end
end
