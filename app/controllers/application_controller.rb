class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :get_site
  before_filter :get_app_menu_actions
  before_filter :get_nav_pages
  before_filter :save_path
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
    @have_wordmark = (@site and @site.wordmark and @site.wordmark.exists?)
    ActionMailer::Base.default_url_options = {:host => request.host_with_port}
  end

  def get_app_menu_actions
    @app_menu_actions = []

    @app_menu_actions << [
      {label: 'Search', path: search_path},
      {label: 'Library', path: messages_path},
      {label: 'Calendar', path: main_calendar_path}
    ]

    if current_user and current_user.administrator?
      @app_menu_actions << [
        {label: 'Accounts', path: accounts_path},
        {label: 'Audit Log', path: audit_logs_path},
        {label: 'Email Lists', path: email_lists_path},
        {label: 'Forms', path: forms_path},
        {label: 'Holidays', path: holidays_path},
        {label: 'Libraries', path: libraries_path},
        {label: 'Newsletters', path: newsletters_path},
        {label: 'Pages', path: pages_path},
        {label: 'Payments', path: payments_path},
        {label: 'Podcast', url:
          (@site and @site.podcast ?
            edit_podcast_url(@site.podcast, {:protocol => 'https'}) :
            new_podcast_url(:protocol => 'https'))},
        {label: 'Resources', path: resources_path},
        {label: 'Site', url: edit_site_url(:protocol => 'https')}
      ]
    end

    if user_signed_in?
      @app_menu_actions << [
        {label: 'My Account', url: edit_account_url(current_user, :protocol => 'https')},
        {label: 'Sign out', url:  destroy_user_session_url(:protocol => 'https'), :method => 'delete', token: session[:_csrf_token]}
      ]
    else
      @app_menu_actions << [
        {label: 'Sign in', url:  new_user_session_url(:protocol => 'https')}
      ]
    end
  end

  def get_nav_pages
    @site_primary_pages = @site ? @site.primary_pages : []
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
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
    else
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation, :administrator) }
    end
  end

end
