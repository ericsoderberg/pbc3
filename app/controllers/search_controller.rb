class SearchController < ApplicationController
  
  def search
    @search_text = params[:q]
    
    #ranges = Bible.verse_ranges(@search_text, true)
    if false and not ranges.empty? # verse
      #@messages = Message.find_by_verses(@search_text)
    elsif @search_text and ! @search_text.strip.empty?
      #classes = [Text, Message, MessageSet, Event, Document, Author]
      classes = [Text, Event, Document]
      classes << Form if user_signed_in?
      classes << User if user_signed_in?
      @search = Sunspot.search(*classes) do
        fulltext params[:q]
        paginate(:page => (params[:page] || 1))
        without(:best, false)
      end
      # convert to generic form
      @results = @search.results.map do |object|
        case object
        when Page then
          {type: 'Page', url: friendly_page_path(object), prefix: object.url_prefix, name: object.name}
        #when Message then
          #{type: 'Message', url: message_path(object), name: object.title}
        #when MessageSet then
          #{type: 'Message Series', url: series_path(object), name: object.title}
        #when Author then
          #{type: 'Author', url: author_path(object), name: object.name}
        when Event then
          {type: 'Event', url: friendly_page_path(object.page), name: object.name,
            page: {name: object.page.name, url:friendly_page_path(object.page)} }
        when Document then
          {type: 'Document', url: object.file.url, name: object.name,
            page: {name: object.page.name, url:friendly_page_path(object.page)} }
        when Form then
          {type: 'Form', url: form_fills_path(object), name: object.name,
            page: {name: object.page.name, url:friendly_page_path(object.page)} }
        when User then
          {type: 'User', url: edit_account_path(object), name: object.name}
        else
          {}
        end
      end
    end
    
    @content_partial = 'search/search'
    
    respond_to do |format|
      format.html { render :action => "search" }
      format.json { render :partial => "search" }
    end
  end

end
