class AddSnippetsToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :snippet_text, :text
    add_column :pages, :snippet_feature_text, :text
  end

  def self.down
    remove_column :pages, :snippet_feature_text
    remove_column :pages, :snippet_text
  end
end
