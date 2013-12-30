class AddPhoneToSite < ActiveRecord::Migration
  def change
    add_column :sites, :phone, :text
  end
end
