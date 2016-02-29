class SearchController < ApplicationController

  def search
    @search_text = params[:q]
    @results = []
    text_regex = /^\#|^\*|^[0-9]\./

    #ranges = Bible.verse_ranges(@search_text, true)
    if false and not ranges.empty? # verse
      #@messages = Message.find_by_verses(@search_text)
    elsif @search_text and ! @search_text.strip.empty?

      Page.search(@search_text).limit(10).each do |page|
        text_element = page.page_elements.where('element_type = ?', 'Text').first
        text = ''
        if text_element
          # strip Markdown down to just text
          text = text_element.element.text.split("\n").
            select{|line| line !~ text_regex}.join("\n")
        end
        @results << {name: page.name, path: friendly_page_path(page), text: text}
      end

      Form.search(@search_text).limit(10).each do |form|
        url = form.page ? friendly_page_path(form.page) : form_fills_url(form)
        form_field = form.form_fields.where('field_type = ?', 'instructions').first
        text = form_field ? form_field.help : '';
        @results << {name: form.name, path: url, text: text}
      end

      Document.search(@search_text).limit(10).each do |document|
        @results << {name: document.name, url: document.file.url}
      end

      Event.search(@search_text).limit(10).each do |event|
        url = event.page ? friendly_page_path(event.page) : edit_event_path(event)
        text = view_context.contextual_times(event)
        @results << {name: event.name, path: url, text: text}
      end

      if user_signed_in?
        User.search(@search_text).limit(10).each do |user|
          @results << {name: user.name, path: edit_account_path(user)}
        end

        Resource.search(@search_text).limit(10).each do |resource|
          @results << {name: resource.name, path: main_calendar_path(search: resource.name)}
        end
      end
    end

    respond_to do |format|
      format.html { render '/home/index' }
      format.json
    end
  end

end
