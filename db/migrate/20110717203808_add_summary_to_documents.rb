class AddSummaryToDocuments < ActiveRecord::Migration
  def self.up
    add_column :documents, :summary, :text
    add_column :documents, :published_at, :date
  end

  def self.down
    remove_column :documents, :published_at
    remove_column :documents, :summary
  end
end
