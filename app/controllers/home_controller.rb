class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => :index
  before_filter :administrator!, :except => :index
  before_filter :get_page, :except => :index
  
  def index
    user = user_signed_in? ? current_user : nil
    @pages = Page.visible(user).where(['featured = ?', true]).order('feature_index ASC')
    @hero_page = Page.find_by_id(params[:page]) || @pages.first
    if @hero_page
      @hero_photo1 = @hero_page.photos.first
      @hero_photo2 = @hero_page.photos[1]
    end
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
