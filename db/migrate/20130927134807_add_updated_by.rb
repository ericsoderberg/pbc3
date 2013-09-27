class AddUpdatedBy < ActiveRecord::Migration
  def self.up
    add_column :pages, :updated_by, :integer
    add_column :events, :updated_by, :integer
    add_column :messages, :updated_by, :integer
    add_column :newsletters, :updated_by, :integer
    add_column :styles, :updated_by, :integer
    add_column :audios, :updated_by, :integer
    add_column :videos, :updated_by, :integer
    add_column :documents, :updated_by, :integer
    add_column :forms, :updated_by, :integer
  end

  def self.down
    remove_column :pages, :updated_by
    remove_column :events, :updated_by
    remove_column :messages, :updated_by
    remove_column :newsletters, :updated_by
    remove_column :styles, :updated_by
    remove_column :audios, :updated_by
    remove_column :videos, :updated_by
    remove_column :documents, :updated_by
    remove_column :forms, :updated_by
  end
end
