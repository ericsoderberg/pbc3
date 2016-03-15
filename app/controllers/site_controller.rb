class SiteController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  before_filter :administrator!, :except => [:show, :new, :create]
  before_filter :not_if_existing, :only => [:new, :create]

  layout "administration"

  def show
    @site = Site.first
    respond_to do |format|
      format.json
    end
  end

  def new
    @site = Site.new
    @pages = Page.sort()

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @site = Site.first
    @pages = Page.sort()
  end

  def create
    @site = Site.new(site_params)

    respond_to do |format|
      if @site.save
        format.html { redirect_to(root_url, :notice => 'Site was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @site = Site.first
    @site.icon = nil if params[:delete_icon]
    @site.wordmark = nil if params[:delete_wordmark]

    respond_to do |format|
      if @site.update_attributes(site_params)
        format.html { redirect_to(root_url, :notice => 'Site was successfully updated.') }
      else
        format.html { render :action => "edit" }
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
    params.require(:site).permit(
      :title, :subtitle, :address, :phone, :copyright, :email, :mailman_owner,
      :check_address, :online_bank_vendor, :paypal_business, :acronym, :icon,
      :library, :calendar, :wordmark, :home_page_id)
  end

end
