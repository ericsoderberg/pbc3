class BooksController < ApplicationController
  
  def index
    @books = VerseParser::BIBLE_BOOKS.map{|b| b[0]}
    @testaments = [{name: 'Old Testament', sections: []},
      {name: 'New Testament', sections: []}]
    testament = @testaments[0]
    section = nil
    @max_count = 0
    @books.each do |book|
      if 'Genesis' == book
        section = {:name => 'Pentatuch', :books => []}
        testament[:sections] << section
      elsif 'Joshua' == book
        section = {:name => 'History', :books => []}
        testament[:sections] << section
      elsif 'Job' == book
        section = {:name => 'Poetry', :books => []}
        testament[:sections] << section
      elsif 'Isaiah' == book
        section = {:name => 'Major Prophets', :books => []}
        testament[:sections] << section
      elsif 'Hosea' == book
        section = {:name => 'Minor Prophets', :books => []}
        testament[:sections] << section
      elsif 'Matthew' == book
        testament = @testaments[1]
        section = {:name => 'Gospels', :books => []}
        testament[:sections] << section
      elsif 'Acts' == book
        section = {:name => 'Church History', :books => []}
        testament[:sections] << section
      elsif 'Romans' == book
        section = {:name => 'Epistles', :books => []}
        testament[:sections] << section
      elsif 'Revelation' == book
        section = {:name => 'Prophecy', :books => []}
        testament[:sections] << section
      end
      count = Message.count_for_book(book)
      section[:books] << {:book => book, :count => count}
      @max_count = [@max_count, count].max
    end
  end

  def show
    @book = params[:id]
    @messages = Message.find_by_verses(@book)
  end

end
