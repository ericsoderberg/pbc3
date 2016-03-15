class HomeController < ApplicationController

  def index
    unless @site
      session.delete(:post_login_path)
      unless current_user
        redirect_to new_user_registration_url(:protocol => 'https')
      else
        redirect_to new_site_url
      end
      return
    end
    user = user_signed_in? ? current_user : nil

    @page = @site.home_page
    if @page and @page.administrator? current_user
      @edit_url = edit_contents_page_url(@page, :protocol => 'https')
    end

    session[:breadcrumbs] = '' # clear breadcrumbs

    respond_to do |format|
      format.html { render :action => "index" }
      format.json { render :partial => "pages/show" }
    end
  end

end
