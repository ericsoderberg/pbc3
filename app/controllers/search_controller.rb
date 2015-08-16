class SearchController < ApplicationController

  def search
    @search_text = params[:q]
    @results = []

    #ranges = Bible.verse_ranges(@search_text, true)
    if false and not ranges.empty? # verse
      #@messages = Message.find_by_verses(@search_text)
    elsif @search_text and ! @search_text.strip.empty?

      Form.search(@search_text).limit(10).each do |form|
        @results << {type: 'Form', url: form_path(form.page), name: form.name,
          page: {name: form.page.name, url: friendly_page_path(form.page)}}
      end

      Document.search(@search_text).limit(10).each do |document|
        @results << {type: 'Document', url: document.file.url, name: document.name,
          page: {name: document.page.name, url: friendly_page_path(document.page)}}
      end

      Event.search(@search_text).limit(10).each do |event|
        @results << {type: 'Event', url: friendly_page_path(event.page), name: event.name,
          page: {name: event.page.name, url: friendly_page_path(event.page)}}
      end

      if user_signed_in?
        User.search(@search_text).limit(10).each do |user|
          @results << {type: 'User', url: edit_account_path(user), name: user.name}
        end

        Resource.search(@search_text).limit(10).each do |resource|
          @results << {type: 'Resource', url: main_calendar_path(search: resource.name), name: resource.name}
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
