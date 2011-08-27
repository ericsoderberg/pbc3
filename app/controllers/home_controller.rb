class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => :index
  before_filter :administrator!, :except => :index
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
    @feature_pages = Page.home_feature_pages(user)
    @feature_strip_pages = @feature_pages[0,5]
  end
  
  def edit
    @home_feature_pages = Page.home_feature_pages(current_user)
    @home_feature_pages << @page unless @home_feature_pages.include?(@page)
    @parent_feature_pages = Page.parent_feature_pages(current_user)
    @parent_feature_pages << @page unless @parent_feature_pages.include?(@page)
  end
  
  def update
    orderer_feature_ids = params[:feature_order] ?
      params[:feature_order].split(',').map{|id| id.to_i} : []
    params[:page][:home_feature_index] = orderer_feature_ids.length + 100
    
    respond_to do |format|
      if @page.update_attributes(params[:page]) and
        (not @page.home_feature? or Page.order_home_features(orderer_feature_ids))
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

end
