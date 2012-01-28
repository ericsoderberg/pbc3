class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :get_site
  before_filter :get_nav_pages
  
  def administrator!
    unless current_user and current_user.administrator?
      redirect_to root_url
      return false
    end
    return true
  end
  
  def page_administrator!(page=@page)
    unless (current_user and
        (current_user.administrator? or
          (page and page.administrator?(current_user))))
      redirect_to root_url
      return false
    end
    return true
  end
  
  def get_page
    @page = Page.find_by_url(params[:page_id])
  end
  
  def get_site
    @site = Site.first
    ActionMailer::Base.default_url_options = {:host => request.host_with_port}
  end
  
  def get_nav_pages
    @communities = (@site ? @site.communities_page.children : [])
    @abouts = (@site ? @site.about_page.children : [])
  end
  
end
