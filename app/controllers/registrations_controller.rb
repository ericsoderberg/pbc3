class RegistrationsController < Devise::RegistrationsController

  layout "administration"

  def new
    super
  end

  def create
    if not params[:user][:email_confirmation].empty?
      redirect_to root_path
      return
    end
    params[:user].delete :email_confirmation
    # make first user an administrator
    params[:user][:administrator] = true unless @site and @site.id
    super
  end

  def update
    super
  end

  protected

  def after_sign_up_path_for(resource_or_scope)
    session[:post_login_path] ? session[:post_login_path] : root_url
  end

  def after_sign_in_path_for(resource_or_scope)
    session[:post_login_path] ? session[:post_login_path] : root_url
  end

  def after_sign_out_path_for(resource_or_scope)
    session[:post_login_path] ? session[:post_login_path] : root_url
  end

end
