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
  
  PAGE_TYPE_VIEWS = {'landing' => 'landing', 'blog' => 'blog',
    'main' => 'main', 'leaf' => 'main', 'post' => 'post'}

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @page = Page.find_by_url(params[:id], :include => :children)
    unless @page and @page.authorized?(current_user)
      redirect_to root_path
      return
    end
    
    if @page.main? or @page.leaf? or @page.post?
      @categorized_events = Event.categorize(@page.related_events)
    end
    @note = Note.new(:page_id => @page.id)

    respond_to do |format|
      format.html { render :action =>
        "show_#{PAGE_TYPE_VIEWS[@page.page_type]}" }
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
    @page.page_type = @page.possible_types.first
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
    @siblings = @page.parent ? @page.parent.children : []
  end
  
  def edit_for_parent
    @page = Page.find_by_url(params[:id])
    @parent = Page.find_by_id(params[:parent_id])
    @siblings = @parent.children.all
    @siblings << @page unless @siblings.include?(@page)
    render :partial => 'edit_for_parent'
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
    orderer_sub_ids = params[:sub_order] ?
      params[:sub_order].split(',').map{|id| id.to_i} : []

    respond_to do |format|
      if @page.update_attributes(params[:page]) and
        (not @page.parent or @page.parent.order_children(orderer_sub_ids))
        format.html { redirect_to(@page, :notice => 'Page was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html {
          @siblings = @page.parent ? @page.parent.children : []
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
    # what about index and feature_index being shifted?

    respond_to do |format|
      format.html { redirect_to(parent ? friendly_page_url(parent) : pages_url) }
      format.xml  { head :ok }
    end
  end
end
