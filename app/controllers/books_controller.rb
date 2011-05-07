class BooksController < ApplicationController
  
  def index
    @books = VerseParser::BIBLE_BOOKS.map{|b| b[0]}
  end

  def show
    @book = params[:id]
    @messages = Message.find_by_verses(@book)
  end

end
