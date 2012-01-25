class Audio < ActiveRecord::Base
  belongs_to :page
  has_attached_file :audio
  has_attached_file :audio2
  acts_as_audited
  
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
