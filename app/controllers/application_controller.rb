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
  
  def get_page
    @page = Page.find_by_url(params[:page_id])
  end
  
  def get_site
    @site = Site.first
  end
  
  def get_nav_pages
    @communities = (@site ? @site.communities_page.children : [])
    @abouts = (@site ? @site.about_page.children : [])
  end
  
end
