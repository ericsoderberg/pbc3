class SessionsController < Devise::SessionsController

  #skip_before_filter :verify_authenticity_token, only: [:destroy]

  layout 'administration'

  def new
    super
  end

  def create
    super
  end

  protected

  def after_sign_in_path_for(resource_or_scope)
    session[:post_login_path] ? session[:post_login_path] : root_url
  end

  def after_sign_out_path_for(resource_or_scope)
    session[:post_login_path] ? session[:post_login_path] : root_url
  end

end
