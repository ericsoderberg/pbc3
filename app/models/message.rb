class Message < ActiveRecord::Base
  belongs_to :message_set
  belongs_to :author
  has_many :verse_ranges, :autosave => true, :dependent => :destroy
  acts_as_url :title
  
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
      order('verse_ranges.begin_index')
  end
  
end
