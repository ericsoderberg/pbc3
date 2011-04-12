class CreateStyles < ActiveRecord::Migration
  def self.up
    create_table :styles do |t|
      t.string :name
      t.string :hero_file_name
      t.string :hero_content_type
      t.integer :hero_file_size
      t.datetime :hero_updated_at
      t.string :banner_file_name
      t.string :banner_content_type
      t.integer :banner_file_size
      t.datetime :banner_updated_at
      t.string :feature_strip_file_name
      t.string :feature_strip_content_type
      t.integer :feature_strip_file_size
      t.datetime :feature_strip_updated_at
      t.integer :gradient_upper_color
      t.integer :gradient_lower_color
      t.integer :hero_text_color
      t.text :css

      t.timestamps
    end
  end

  def self.down
    drop_table :styles
  end
end
