class AddPromptToFormField < ActiveRecord::Migration
  def change
    add_column :form_fields, :prompt, :string
  end
end
