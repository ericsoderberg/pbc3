class SearchController < ApplicationController
  
  def search
    @search_text = params[:q]
    
    ranges = VerseParser.new(@search_text, true).ranges
    if not ranges.empty? # verse
      @messages = Message.find_by_verses(@search_text)
    elsif @search_text and ! @search_text.strip.empty?
      classes = [Page, Message, MessageSet, Event, Document, Author]
      classes << Form if user_signed_in?
      classes << User if user_signed_in?
      classes << Style if user_signed_in? and current_user.administrator?
      @search = Sunspot.search(*classes) do
        fulltext params[:q]
        paginate(:page => (params[:page] || 1))
        without(:best, false)
      end
    end
  end

end
