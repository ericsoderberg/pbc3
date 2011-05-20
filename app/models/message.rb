class Message < ActiveRecord::Base
  belongs_to :message_set
  belongs_to :author
  has_many :verse_ranges, :autosave => true, :dependent => :destroy
  has_many :message_files, :dependent => :destroy
  acts_as_url :title, :sync_url => true
  acts_as_audited
  
  validates :title, :presence => true
  
  def to_param
    url
  end
  
  before_save :setup_verse_ranges
  
  def setup_verse_ranges
    ranges = VerseParser.new(self.verses).ranges
    verse_ranges.clear
    ranges.each do |range|
      verse_ranges.build(:begin_index => range[:begin][:index],
        :end_index => range[:end][:index])
    end
  end
  
  def intersects?(verse_span)
    verse_ranges.detect{|r| r.intersects?(verse_span)}
  end
  
  def self.find_by_verses(verses)
    ranges = verses.is_a?(String) ? VerseParser.new(verses).ranges : verses
    return [] if ranges.empty?
    wheres = []
    ranges.each do |range|
      wheres << "(verse_ranges.end_index >= #{range[:begin][:index]}" +
        "AND verse_ranges.begin_index <= #{range[:end][:index]})"
    end
    Message.includes(:verse_ranges).
      where(wheres.join(' OR ')).
      order('date desc').
      order('verse_ranges.begin_index')
  end
  
  def self.between(start_date, end_date)
    where('date >= ? AND date < ?', start_date, end_date)
  end
  
  def emebedded_content
    message_file = message_files.where(
      "file_file_name LIKE '%.txt' OR file_file_name LIKE '%.html'").first
    return '' unless message_file
    'TBD'
  end
  
  def audio_message_files
    message_files.select{|mf| mf.audio?}
  end
  
  def self.merge_messages_and_sets(messages, message_sets)
    result = []
    while (not messages.empty? or not message_sets.empty?) do
      if not messages.empty? and
        (message_sets.empty? or
          message_sets.first.messages.first.date < messages.first.date)
        result << messages.shift
      else
        result << message_sets.shift
      end
    end
    result
  end
  
end
