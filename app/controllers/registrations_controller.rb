class RegistrationsController < Devise::RegistrationsController
  
  def new
    super
  end

  def create
    if not params[:user][:email_confirmation].empty?
      redirect_to root_path
      return
    end
    super
  end

  def update
    super
  end
end
