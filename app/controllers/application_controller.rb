class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :get_site
  before_filter :get_nav_pages
  before_filter :save_path
  
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
  
  def save_path
    if request.referrer !~ /sign_in/ and request.referrer !~ /sign_out/ and
      request.referrer !~ /password/
      session[:post_login_path] = request.referrer
    end
  end
  
  def after_sign_in_path_for(resource_or_scope)
    session[:post_login_path] ? session[:post_login_path] : root_url
  end
  
  def after_sign_out_path_for(resource_or_scope)
    session[:post_login_path] ? session[:post_login_path] : root_url
  end
  
end
