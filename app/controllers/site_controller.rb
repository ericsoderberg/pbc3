class SiteController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!, :except => [:new, :create]
  before_filter :not_if_existing, :only => [:new, :create]
  
  # GET /sites/new
  # GET /sites/new.xml
  def new
    @site = Site.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @site }
    end
  end

  # GET /sites/1/edit
  def edit
    @site = Site.first
  end

  # POST /sites
  # POST /sites.xml
  def create
    @site = Site.new(site_params)

    respond_to do |format|
      if @site.save
        format.html { redirect_to(root_url, :notice => 'Site was successfully created.') }
        format.xml  { render :xml => @site, :status => :created, :location => @site }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sites/1
  # PUT /sites/1.xml
  def update
    @site = Site.first
    @site.icon = nil if params[:delete_icon]
    @site.wordmark = nil if params[:delete_wordmark]

    respond_to do |format|
      if @site.update_attributes(site_params)
        format.html { redirect_to(root_url, :notice => 'Site was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  
  def not_if_existing
    if @site
      redirect_to root_url
      return false
    end
  end
  
  def site_params
    params.require(:site).permit(:communities_page_id, :about_page_id,
      :title, :subtitle, :address, :phone, :copyright, :email, :mailman_owner,
      :check_address, :online_bank_vendor, :paypal_business, :acronym, :icon,
      :library, :calendar, :wordmark)
  end
  
end
