module ApplicationHelper

  def title(page_title)
    suffix = if @site and page_title != @site.title
      if @site.acronym and not @site.acronym.empty?
        ' - ' + @site.acronym
      elsif @site.title and not @site.title.empty?
        ' - ' + @site.title
      end
    end
    content_for(:title) {
      page_title + (suffix ? suffix : '')
    }
  end

  def site_header_class
    result = []
    result << 'have_wordmark' if @have_wordmark
    result << 'have_breadcrumbs' if content_for?(:breadcrumbs)
    result.join(' ')
  end

  def site_title
    if @have_wordmark
      ''
    elsif @site and @site.title
      # upcase and put a span around the first word
      first, rest = @site.title.split(' ', 2)
      "<span>#{h first}</span> <span>#{h rest}</span>"
    else
      'Home'
    end
  end

  def site_logo
    (@have_wordmark ?
      image_tag(@site.wordmark.url, :class => 'wordmark') : '') +
    image_tag(site_icon_url, :class => 'icon')
  end

  def site_icon_url
    if @site and @site.icon and @site.icon.exists?
      @site.icon.url
    else
      image_url('blank-icon.png')
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

  def array_to_rows(array, columns=4)
    row_count = (array.size + columns - 1) / columns
    rows = (1..row_count).map{[]}
    index = 0
    array.each do |item|
      rows[index] << item
      index += 1
      index = 0 if index >= row_count
    end
    rows
  end

  def administrator?
    current_user and current_user.administrator?
  end

end
