class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def administrator!
    unless current_user and current_user.administrator
      redirect_to root_url
      return false
    end
    return true
  end
  
  def get_page
    @page = Page.find_by_url(params[:page_id])
  end
  
end
