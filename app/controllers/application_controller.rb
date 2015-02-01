class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :get_site
  before_filter :get_nav_pages
  before_filter :save_path
  before_filter :get_design
  before_filter :configure_permitted_parameters, if: :devise_controller?

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
    @page = Page.find_by(url: params[:page_id])
  end

  def get_site
    @site = Site.first
    @have_wordmark = @site and @site.wordmark and @site.wordmark.exists?
    ActionMailer::Base.default_url_options = {:host => request.host_with_port}
  end

  def get_nav_pages
    @site_primary_pages = @site ? @site.primary_pages : []
    #@communities = (@site and @site.communities_page ?
    #  [@site.communities_page] + @site.communities_page.children : [])
    #@abouts = (@site and @site.about_page ? [@site.about_page] + @site.about_page.children : [])
  end

  def get_design
    if params['_design']
      if params['_design'].empty?
        cookies.delete 'design'
      else
        cookies.permanent['design'] = params['_design']
      end
    end
    session[:design] = cookies['design'] || 'morocco'
  end

  def save_path

    if request.referer
      referer_path = URI(request.referer).path
      if not referer_path.starts_with?('/users/sign_') and
        not referer_path.starts_with?('/users/password') and
        not referer_path.starts_with?('/password') and
        not referer_path.starts_with?('/private')
        session[:post_login_path] = session[:post_login_path_override] || request.referer
        session.delete(:post_login_path_override)
      end
    end
  end

  def mobile_device?
    request.user_agent =~ /Mobile|webOS/
  end
  helper_method :mobile_device?

  def phone_device?
    request.user_agent.downcase =~ /iphone|ipod/
  end
  helper_method :phone_device?

  protected

  def configure_permitted_parameters
    if @site and @site.id
      devise_parameter_sanitizer.sanitize(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
    else
      devise_parameter_sanitizer.sanitize(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation, :administrator) }
    end
  end

end
