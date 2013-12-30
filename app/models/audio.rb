class Audio < ActiveRecord::Base
  belongs_to :page
  has_attached_file :audio,
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
  has_attached_file :audio2,
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
  belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by'
  
  validates_presence_of :page
  
  def authorized?(user)
    page.authorized?(user)
  end
  
  def self.fix_sizes
    where('audio_file_size IS NULL').each do |audio|
      if audio.audio and audio.audio.to_file
        File.open(audio.audio.to_file, 'r') do |file|
          audio.audio_file_size = file.size
          audio.save
        end
      end
    end
  end
  
end
