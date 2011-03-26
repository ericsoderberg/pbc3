class AddRenderedTextToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :rendered_text, :text
  end

  def self.down
    remove_column :pages, :rendered_text
  end
end
