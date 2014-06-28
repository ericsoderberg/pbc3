class AddWordmarkToSites < ActiveRecord::Migration
  def change
    add_column :sites, :wordmark_file_name, :string
    add_column :sites, :wordmark_content_type, :string
    add_column :sites, :wordmark_file_size, :integer
    add_column :sites, :wordmark_updated_at, :datetime
  end
end
