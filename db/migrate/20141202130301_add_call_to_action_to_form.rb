class AddCallToActionToForm < ActiveRecord::Migration
  def change
    add_column :forms, :call_to_action, :string
  end
end
