class RenameTextsInPages < ActiveRecord::Migration
  def self.up
    rename_column :pages, :feature_text, :hero_text
    rename_column :pages, :snippet_feature_text, :feature_phrase
    remove_column :pages, :rendered_feature_text
    remove_column :pages, :rendered_text
  end

  def self.down
    add_column :pages, :rendered_feature_text, :string
    add_column :pages, :rendered_text, :string
    rename_column :pages, :hero_text, :feature_text
    rename_column :pages, :feature_phrase, :snippet_feature_text
  end
end
