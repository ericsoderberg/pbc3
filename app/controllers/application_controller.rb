class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def administrator!
    unless current_user and current_user.administrator
      redirect_to root_url
      return false
    end
    return true
  end
  
end
