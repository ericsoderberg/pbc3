xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0",
  'xmlns:atom' => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title @page.name
    xml.link friendly_page_url(@page)
    xml.language 'en-us'
    xml.description @page.snippet_text
    xml.atom :link,
      :href => friendly_page_podcast_url(@page),
      :rel => 'self', :type => 'application/rss+xml'

    for child in @page.children
      xml.item do
        xml.title child.name
        xml.description child.snippet_text
        xml.pubDate child.updated_at.to_s(:rfc822)
        xml.link friendly_page_url(child)
        xml.guid friendly_page_url(child)
      end
    end
    
  end
end
