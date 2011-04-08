class PageBannersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!
  
  # GET /page_banners
  # GET /page_banners.xml
  def index
    @page_banners = PageBanner.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @page_banners }
    end
  end

  # GET /page_banners/1
  # GET /page_banners/1.xml
  def show
    @page_banner = PageBanner.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page_banner }
    end
  end

  # GET /page_banners/new
  # GET /page_banners/new.xml
  def new
    @page_banner = PageBanner.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page_banner }
    end
  end

  # GET /page_banners/1/edit
  def edit
    @page_banner = PageBanner.find(params[:id])
  end

  # POST /page_banners
  # POST /page_banners.xml
  def create
    @page_banner = PageBanner.new(params[:page_banner])

    respond_to do |format|
      if @page_banner.save
        format.html { redirect_to(page_banners_url, :notice => 'Page banner was successfully created.') }
        format.xml  { render :xml => @page_banner, :status => :created, :location => @page_banner }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page_banner.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /page_banners/1
  # PUT /page_banners/1.xml
  def update
    @page_banner = PageBanner.find(params[:id])

    respond_to do |format|
      if @page_banner.update_attributes(params[:page_banner])
        format.html { redirect_to(page_banners_url, :notice => 'Page banner was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page_banner.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /page_banners/1
  # DELETE /page_banners/1.xml
  def destroy
    @page_banner = PageBanner.find(params[:id])
    @page_banner.destroy

    respond_to do |format|
      format.html { redirect_to(page_banners_url) }
      format.xml  { head :ok }
    end
  end
end
