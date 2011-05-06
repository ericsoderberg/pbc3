class PagesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :feed]
  before_filter :administrator!, :except => [:show, :feed]
  
  # GET /pages
  # GET /pages.xml
  def index
    @pages = Page.order("name ASC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @page = Page.find_by_url(params[:id], :include => :children)
    unless @page and @page.authorized?(current_user)
      redirect_to root_path
      return
    end
    
    @upcoming_events = Event.prune(@page.related_events) unless @page.landing?
    @note = Note.new(:page_id => @page.id)

    respond_to do |format|
      format.html {
          render :action => (@page.landing? ? 'show_landing' : 'show') }
      format.xml  { render :xml => @page }
    end
  end
  
  def feed
    @page = Page.find_by_url(params[:id], :include => :children)
    unless @page and @page.authorized?(current_user)
      redirect_to root_path
      return
    end
    @pages = @page.children.order("updated_at DESC").limit(20) 

    respond_to do |format|
      format.html
      format.rss { render :layout => false } #feed.rss.builder
    end
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @page = Page.new
    @page.parent = Page.find_by_id(params[:parent_id])
    @page.index = @page.parent ? @page.parent.children.length + 1 : 1
    @page.style = (@page.parent ? @page.parent.style : Style.first)
    @page.private = @page.parent.private if @page.parent
    if params[:site_page]
      @site_reference = params[:site_page]
      @page.name = @site_reference.capitalize
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find_by_url(params[:id])
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = Page.new(params[:page])
    @page.index = @page.parent ? @page.parent.children.length + 1 : 1
    if params[:site_reference]
      @site.communities_page = @page if 'communities' == params[:site_reference]
      @site.about_page = @page if 'about' == params[:site_reference]
    end

    respond_to do |format|
      if @page.save and (not params[:site_reference] or @site.save)
        format.html { redirect_to(@page, :notice => 'Page was successfully created.') }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = Page.find_by_url(params[:id])
    @page.text_image = nil if params[:delete_text_image]
    if params[:page][:parent_id] != @page.parent_id
      # user changed parent page
      if params[:page][:parent_id]
        # set index to the end
        new_parent = Page.find(params[:page][:parent_id])
        params[:page][:index] = new_parent.children.length + 1
      end
      orderer_sub_ids = []
    else
      orderer_sub_ids = params[:sub_order].split(',').map{|id| id.to_i}
    end

    respond_to do |format|
      if @page.update_attributes(params[:page]) and
        (not @page.parent or @page.parent.order_children(orderer_sub_ids))
        format.html { redirect_to(@page, :notice => 'Page was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html {
          @aspect = params[:aspect] || 'text'
          render :action => "edit"
        }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find_by_url(params[:id])
    parent = @page.parent
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(parent ? friendly_page_url(parent) : pages_url) }
      format.xml  { head :ok }
    end
  end
end
