class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => :index
  before_filter :administrator!, :except => :index
  before_filter :get_page, :except => :index
  
  def index
    user = user_signed_in? ? current_user : nil
    @pages = Page.home_pages(user)
  end
  
  def edit
  end
  
  def update
    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to(@page, :notice => 'Page was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

end
