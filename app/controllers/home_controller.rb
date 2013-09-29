class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :private]
  before_filter :administrator!, :except => [:index, :private]
  before_filter :get_page, :except => :index
  
  def index
    unless @site
      unless current_user
        redirect_to new_user_registration_url(:protocol => 'https')
      else
        redirect_to new_site_url
      end
      return
    end
    user = user_signed_in? ? current_user : nil
    
    @next_message = Home.next_message
    @previous_message = Home.previous_message
    @events = Home.events
    @route_prefix = request.protocol + request.host_with_port
    @feature_pages = Page.home_feature_pages(user)
    @feature_strip_pages = @feature_pages[0,5]
    
    if 'modo' == session[:design]
      render 'home/modo/index'
    end
  end
  
  def edit
    @home_feature_pages = Page.home_feature_pages(current_user)
    @home_feature_pages << @page unless @home_feature_pages.include?(@page)
    if @page.parent
      @parent_feature_pages = @page.parent.feature_children(current_user)
      @parent_feature_pages << @page unless @parent_feature_pages.include?(@page)
    end
  end
  
  def update
    orderer_home_feature_ids = params[:home_feature_order] ?
      params[:home_feature_order].split(',').map{|id| id.to_i} : []
    params[:page][:home_feature_index] = orderer_home_feature_ids.length + 100
    orderer_parent_feature_ids = params[:parent_feature_order] ?
      params[:parent_feature_order].split(',').map{|id| id.to_i} : []
    params[:page][:parent_feature_index] = orderer_parent_feature_ids.length + 100
    
    respond_to do |format|
      if @page.update_attributes(page_params) and
        (not @page.home_feature? or
          Page.order_home_features(orderer_home_feature_ids)) and
        (not @page.parent_feature? or
          Page.order_parent_features(orderer_parent_feature_ids))
        format.html { redirect_to(edit_page_path(@page), :notice => 'Page was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html {
          @home_feature_pages = Page.home_feature_pages(current_user)
          @home_feature_pages << @page unless @home_feature_pages.include?(@page)
          @parent_feature_pages = Page.parent_feature_pages(current_user)
          @parent_feature_pages << @page unless @parent_feature_pages.include?(@page)
          render :action => "edit"
        }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  
  def page_params
    params.require(:page).permit(:hero_text, :home_feature,
      :feature_phrase, :home_feature_index, :feature_upcoming, :parent_feature,
      :parent_feature_index,
      :updated_by).merge(:updated_by => current_user)
  end

end
