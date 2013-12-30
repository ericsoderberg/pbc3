class AddSitePrimaryToPage < ActiveRecord::Migration
  def change
    add_column :pages, :site_primary, :boolean, default: false
  end
end
