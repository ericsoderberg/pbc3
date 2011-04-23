xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @podcast.title
    xml.link friendly_page_url(@page)
    xml.language 'en-us'
    xml.itunes :subtitle, @podcast.subtitle
    xml.itunes :author, @podcast.owner.name
    xml.itunes :summary, @podcast.summary
    xml.description @podcast.description
    xml.itunes :owner do
      xml.itunes :name, @podcast.owner.name
      xml.itunes :email, @podcast.owner.email
    end
    xml.itunes :image, @podcast.image.url
    xml.itunes :category, @podcast.category

    for page in @podcast.pages
      xml.item do
        xml.title page.name
        xml.description page.rendered_text
        xml.pubDate page.updated_at.to_s(:rfc822)
        xml.link friendly_page_url(page)
        xml.guid friendly_page_url(page)
      end
    end
  end
end
