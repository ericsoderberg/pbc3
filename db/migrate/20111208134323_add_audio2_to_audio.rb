class AddAudio2ToAudio < ActiveRecord::Migration
  def self.up
    add_column :audios, :audio2_file_name, :string
    add_column :audios, :audio2_content_type, :string
    add_column :audios, :audio2_file_size, :integer
    add_column :audios, :audio2_updated_at, :datetime
  end

  def self.down
    remove_column :audios, :audio2_updated_at
    remove_column :audios, :audio2_file_size
    remove_column :audios, :audio2_content_type
    remove_column :audios, :audio2_file_name
  end
end
