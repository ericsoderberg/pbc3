class AddEventToForms < ActiveRecord::Migration
  def change
    add_column :forms, :event_id, :integer
  end
end
