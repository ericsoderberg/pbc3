xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0",
  'xmlns:itunes' => "http://www.itunes.com/dtds/podcast-1.0.dtd" do
  xml.channel do
    xml.title @podcast.title
    xml.link (@page ? friendly_page_url(@page) : messages_url)
    xml.language 'en-us'
    xml.itunes :subtitle, @podcast.subtitle
    xml.itunes :author, (@page ? @page.name : @site.title)
    xml.itunes :summary, @podcast.summary
    xml.description @podcast.description
    xml.itunes :owner do
      xml.itunes :name, @podcast.owner.name
      xml.itunes :email, @podcast.owner.email
    end
    xml.itunes :image, :href => 'http://' + request.host_with_port + @podcast.image.url
    xml.itunes :category, :text => @podcast.category do
      xml.itunes :category, :text => @podcast.sub_category
    end
    xml.itunes :explicit, :clean

    if @page
      for page in @podcast.pages
        xml.item do
          xml.title page.name
          xml.description page.snippet_text
          xml.pubDate page.updated_at.to_s(:rfc822)
          xml.link friendly_page_url(page)
          xml.guid friendly_page_url(page)
        end
      end
    else
      for message in @podcast.messages
        xml.item do
          xml.title message.title
          xml.description message.description
          xml.pubDate message.date.to_s(:rfc822)
          xml.link message_url(message)
          message_file = message.audio_message_files.first
          if message_file and message_file.file
            url = 'http://' + request.host_with_port + message_file.file.url
            xml.enclosure :url => url, :length => message_file.file.size,
              :type => message_file.file.content_type
            xml.guid url
          else
            xml.guid message_url(message)
          end
        end
      end
    end
    
  end
end
