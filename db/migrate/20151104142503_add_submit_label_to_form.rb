class AddSubmitLabelToForm < ActiveRecord::Migration
  def change
    add_column :forms, :submit_label, :string
  end
end
