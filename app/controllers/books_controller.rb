class BooksController < ApplicationController
  
  def index
    @books = VerseParser::BIBLE_BOOKS.map{|b| b[0]}
    @sections = []
    section = nil
    @books.each do |book|
      if 'Genesis' == book
        section = {:name => 'Pentatuch', :books => []}
        @sections << section
      elsif 'Joshua' == book
        section = {:name => 'History', :books => []}
        @sections << section
      elsif 'Job' == book
        section = {:name => 'Poetry', :books => []}
        @sections << section
      elsif 'Isaiah' == book
        section = {:name => 'Major Prophets', :books => []}
        @sections << section
      elsif 'Hosea' == book
        section = {:name => 'Minor Prophets', :books => []}
        @sections << section
      elsif 'Matthew' == book
        section = {:name => 'Gospels', :books => []}
        @sections << section
      elsif 'Acts' == book
        section = {:name => 'Church History', :books => []}
        @sections << section
      elsif 'Romans' == book
        section = {:name => 'Epistles', :books => []}
        @sections << section
      elsif 'Revelation' == book
        section = {:name => 'Prophecy', :books => []}
        @sections << section
      end
      section[:books] << book
    end
  end

  def show
    @book = params[:id]
    @messages = Message.find_by_verses(@book)
  end

end
