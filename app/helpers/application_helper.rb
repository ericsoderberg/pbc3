module ApplicationHelper
  
  def title(page_title)
    content_for(:title) {page_title}
  end
  
  def site_title
    if @site and @site.title
      # upcase and put a span around the first word
      first, rest = @site.title.upcase.split(' ', 2)
      "<span>#{h first}</span> #{h rest}"
    else
      'Home'
    end
  end
  
  def communities_path
    if @site and @site.communities_page
      friendly_page_path(@site.communities_page)
    else
      new_page_path(:site_page => :communities)
    end
  end
  
  def about_path
    if @site and @site.about_page
      friendly_page_path(@site.about_page)
    else
      new_page_path(:site_page => :about)
    end
  end
      
end
