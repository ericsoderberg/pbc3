class Fixnum
  def digit?
    self.between?(?0.ord, ?9.ord)
  end
  def alpha?
    self.between?(?a.ord, ?z.ord) or self.between?(?A.ord, ?Z.ord)
  end
  def space?
    self == ?\s.ord or self == ?\t.ord or self == ?\r.ord or self == ?\n.ord
  end
end 

  class Verse
    
    def initialize(index)
      @book = (index / VerseParser::BOOK_OFFSET)
      @chapter = ((index % VerseParser::BOOK_OFFSET) / VerseParser::CHAPTER_OFFSET)
      @verse = (index % VerseParser::CHAPTER_OFFSET)
      @index = index
    end
    
    attr_reader :book, :chapter, :verse, :index
    
    def to_s
      reference = VerseParser::BIBLE_BOOKS.map{|b| b[0]}[@book].dup
      if @chapter > 0 and @chapter < (VerseParser::CHAPTER_OFFSET - 1)
        reference << " %d" % @chapter
        if @verse > 0  and @verse < (VerseParser::CHAPTER_OFFSET - 1)
          reference << ":%d" % @verse
        end
      end
      reference
    end
  
  end
  
  class VerseSpan
    
    def initialize(begin_verse, end_verse)
      @begin_verse = begin_verse.is_a?(Verse) ? begin_verse : Verse.new(begin_verse)
      @end_verse = end_verse.is_a?(Verse) ? end_verse : Verse.new(end_verse)
    end
    
    attr_reader :begin_verse, :end_verse
    
    def to_s
      reference = @begin_verse.to_s
      if @begin_verse.book != @end_verse.book
        reference << (sparse? ? ', .., ' : '-')
        reference << @end_verse.to_s
      elsif @begin_verse.chapter != @end_verse.chapter
        reference << "-%d" % @end_verse.chapter
        if @end_verse.verse > 0 and
           @end_verse.verse < (VerseParser::CHAPTER_OFFSET - 1)
          reference << ":%d" % @end_verse.verse
        end
      elsif @begin_verse.verse != @end_verse.verse
        reference << "-%d" % @end_verse.verse
      end
      reference
    end
    
    def single_book?
      @begin_verse.book == @end_verse.book
    end
    
    def intersects?(verse_span)
      @begin_verse.index < verse_span.end_verse.index and
      @end_verse.index > verse_span.begin_verse.index
    end
    
    def sparse?
      @begin_verse.book != @end_verse.book and
      @begin_verse.verse != 0 and
      @end_verse.verse != (VerseParser::CHAPTER_OFFSET - 1) and
      @begin_verse.book != (@end_verse.book + 1)
    end
    
  end

  class VerseParser

    TRACE_PARSING = false

    BIBLE_BOOKS = [
      ["Genesis", "ge"],
      ["Exodus", "ex"],
      ["Leviticus", "le"],
      ["Numbers", "nu"],
      ["Deuteronomy", "de"],
      ["Joshua", " jos"],
      ["Judges", " judg"],
      ["Ruth", "ru"],
      ["1Samuel", "1sa", "1 sa", "1st sa"],
      ["2Samuel", "2sa", "2 sa", "2nd sa"],
      ["1Kings", "1ki", "1 ki", "1st ki"],
      ["2Kings", "2ki", "2 ki", "2nd ki"],
      ["1Chronicles", "1ch", "1 ch", "1st ch"],
      ["2Chronicles", "2ch", "2 ch", "2nd ch"],
      ["Ezra", "ezr"],
      ["Nehemiah", "ne"],
      ["Esther", "es"],
      ["Job", "job"],
      ["Psalms", "ps"],
      ["Proverbs", "pr"],
      ["Ecclesiastes", "ec"],
      ["Songofsongs", "so"],
      ["Isaiah", "isa"],
      ["Jeremiah", "jer"],
      ["Lamentations", "la"],
      ["Ezekiel", "eze"],
      ["Daniel", "da"],
      ["Hosea", "ho"],
      ["Joel", "joe"],
      ["Amos", "am"],
      ["Obadiah", "ob"],
      ["Jonah", "jon"],
      ["Micah", "mic"],
      ["Nahum", "na"],
      ["Habakkuk", "hab"],
      ["Zephaniah", "zep"],
      ["Haggai", "hag"],
      ["Zechariah", "zec"],
      ["Malachi", "mal"],
      ["Matthew", "mat"],
      ["Mark", "mar"],
      ["Luke", "lu"],
      ["John", "joh"],
      ["Acts", "ac"],
      ["Romans", "ro"],
      ["1Corinthians", "1co", "1 co", "1st co"],
      ["2Corinthians", "2co", "2 co", "2nd co"],
      ["Galatians", "ga"],
      ["Ephesians", "eph"],
      ["Philippians", "phili"],
      ["Colossians", "col"],
      ["1Thessalonians", "1th", "1 th", "1st th"],
      ["2Thessalonians", "2th", "2 th", "2nd th"],
      ["1Timothy", "1ti", "1 ti", "1st ti"],
      ["2Timothy", "2ti", "2 ti", "2nd ti"],
      ["Titus", "tit"],
      ["Philemon", "phile"],
      ["Hebrews", "heb"],
      ["James", "jas"],
      ["1Peter", "1pe", "1 pe", "1st pe"],
      ["2Peter", "2pe", "2 pe", "2nd pe"],
      ["1John", "1jo", "1 jo", "1jn", "1 jn", "1st jo"],
      ["2John", "2jo", "2 jo", "2jn", "2 jn", "2nd jo"],
      ["3John", "3jo", "3 jo", "3jn", "3 jn", "3rd jo"],
      ["Jude", "jude"],
      ["Revelation", "re"]
    ]
    
    BOOK_OFFSET = 1000000
    CHAPTER_OFFSET = 1000

    def initialize(string=nil, strict=false)
      @s = string ? string.strip : ''
      self.strict = strict
      @ranges = nil
    end
    
    attr_accessor :strict;

    def ranges
      parse_ranges if @ranges.nil?
      return @ranges
    end

    private
    
    # convert a string containing verse references into an array of ranges.
    # for example, 'Genesis 1:1-5' would result in:
    # e.g. [{:begin => {:book => 1, :chapter => 1, :verse => 1},
    #        :end => {:book => 1, :chapter => 1, :verse => 5}}]
    def parse_ranges
      @ranges = [] # the outer array
      range = {}
      context = nil

      while @s and not @s.empty?

        print "working on #{@s}\n" if TRACE_PARSING

        reference = parse_reference(context)
        break unless reference

        if range.empty?
          range[:begin] = reference
        else
          range[:end] = reference
        end
        context = nil

        unless not @s or @s.empty?
          if ?, == @s[0] or ?; == @s[0]
            range[:end] = generate_end_reference(range[:begin]) unless range[:end]
            @ranges << range
            range = {}
          elsif ?- == @s[0]
            # ok
          else
            # unknown delimiter
            range[:end] = generate_end_reference(range[:begin]) unless range[:end]
            @ranges << range
            return
          end
          @s = @s.slice(1..-1).strip # remove this delimiter and trailing whitespace
          context = reference.dup # set the context based on the current reference

          # had a verse, probably have a new verse
          if reference.has_key?(:verse)
            context.delete(:verse)
          end
          # might have a new chapter
          if not reference.has_key?(:verse) or
            (reference.has_key?(:verse) and next_is_chapter?)
            context.delete(:chapter)
          end
          # might have a new book
          if next_is_book?
            context = nil
          end
        end

        if 2 == range.length
            @ranges << range
            range = {}
        end
      end

      unless range.empty?
        range[:end] = generate_end_reference(range[:begin]) unless range[:end]
        @ranges << range
      end
    end

    def generate_end_reference(begin_reference)
      end_reference = {:index => begin_reference[:book] * BOOK_OFFSET}
      end_reference[:index] += begin_reference[:chapter] ?
        begin_reference[:chapter] * CHAPTER_OFFSET : (BOOK_OFFSET - CHAPTER_OFFSET)
      end_reference[:index] += begin_reference[:verse] ?
        begin_reference[:verse] : (CHAPTER_OFFSET - 1)
      print "generated end reference #{end_reference}\n" if TRACE_PARSING
      return end_reference
    end

    def parse_reference(context=nil)
      reference = {}
      print "parse reference at: #{@s}\n" if TRACE_PARSING
      print "context: #{context}\n" if TRACE_PARSING
      if not context
        reference[:book] = parse_book
        return nil if reference[:book] == nil or
                      reference[:book] > CHAPTER_OFFSET # sanity check
      else
        reference[:book] = context[:book]
      end
      reference[:index] = reference[:book] * BOOK_OFFSET
      if (not context or not context.has_key?(:chapter)) and
        not @s.empty? and @s[0].ord.digit?
        reference[:chapter] = parse_number
        return nil if reference[:chapter] > CHAPTER_OFFSET # sanity check
      elsif context and context.has_key?(:chapter)
        reference[:chapter] = context[:chapter]
      end
      reference[:index] += reference[:chapter] * CHAPTER_OFFSET if reference[:chapter]
      if @s and ?: == @s[0]
        @s = @s.slice(1..-1).strip
        reference[:verse] = parse_number
        return nil if reference[:verse] > CHAPTER_OFFSET # sanity check
      elsif (not context or not context.has_key?(:verse)) and
            not @s.empty? and @s[0].ord.digit?
        reference[:verse] = parse_number
        return nil if reference[:verse] > CHAPTER_OFFSET # sanity check
      end
      reference[:index] += reference[:verse] if reference[:verse]
      print "reference is #{reference} with #{@s}\n" if TRACE_PARSING
      return reference
    end

    def parse_book
      print "parse book at: #{@s}\n" if TRACE_PARSING
      # find the book name by matching against all patterns
      book = nil
      BIBLE_BOOKS.each_with_index do |ba, i|
        ba.each do |b|
          if @s.downcase.starts_with?(b.downcase)
            book = i
            break
          end
          break if strict # only first full pattern is checked when strict
        end
        break unless book.nil?
      end
      return nil if book.nil?

      # find the extent of the book name and strip it off
      i = 0
      if @s[i].ord.digit?
          # skip initial number and spaces (e.g. "1 Cor")
          i += 1
          while @s[i].ord.space?
              i += 1
          end
      end
      # skip until first non alpha
      while i < @s.length and @s[i].ord.alpha?
          i += 1
      end
      @s = @s.slice(i..-1).strip
      print "book is #{book} with #{@s}\n" if TRACE_PARSING
      return book
    end

    def parse_number
      print "parse number at: #{@s}\n" if TRACE_PARSING
      @s =~ /^(\d+)(.*)$/
      number = $1
      @s = $2
      print "number is #{number} with #{@s}\n" if TRACE_PARSING
      return number.to_i
    end

    def next_is_book?
      @s.bytes do |c|
        return true if c.alpha?
        return false unless c.space?
        # skip over punctuation like '-', as in "Genesis - Revelation"
        ##i += 1
      end
      return false
    end

    def next_is_chapter?
      return false if @s.empty?
      colon_index = @s.index(':')
      return false if colon_index.nil?
      comma_index = @s.index(',')
      semicolon_index = @s.index(';')
      return true if comma_index.nil? and semicolon_index.nil?
      return false if not comma_index.nil? and comma_index < colon_index
      return false if not semicolon_index.nil? and semicolon_index < colon_index
      return true
    end
  end
