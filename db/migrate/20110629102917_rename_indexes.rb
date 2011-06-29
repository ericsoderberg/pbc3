class RenameIndexes < ActiveRecord::Migration
  def self.up
    rename_column :pages, :index, :parent_index
    rename_column :form_field_options, :index, :form_field_index
    rename_column :form_fields, :index, :form_index
    rename_column :messages, :index, :message_set_index
  end

  def self.down
    rename_column :pages, :parent_index, :index
    rename_column :form_field_options, :form_field_index, :index
    rename_column :form_fields, :form_index, :index
    rename_column :messages, :message_set_index, :index
  end
end
