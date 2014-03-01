class AddAuthenticationTextToForm < ActiveRecord::Migration
  def change
    add_column :forms, :authentication_text, :text
  end
end
