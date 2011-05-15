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
    @pages = Page.home_pages(user)
  end
  
  def edit
    @feature_pages = Page.where('featured = ?', true).all
    @feature_pages << @page unless @feature_pages.include?(@page)
  end
  
  def update
    orderer_feature_ids = params[:feature_order] ?
      params[:feature_order].split(',').map{|id| id.to_i} : []
    params[:page][:feature_index] = orderer_feature_ids.length + 100
    
    respond_to do |format|
      if @page.update_attributes(params[:page]) and
        (not @page.featured? or Page.order_features(orderer_feature_ids))
        format.html { redirect_to(@page, :notice => 'Page was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html {
          @feature_pages = Page.where('featured = ?', true).all
          @feature_pages << @page unless @feature_pages.include?(@page)
          render :action => "edit"
        }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

end
