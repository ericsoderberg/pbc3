class PagesController < ApplicationController
  before_filter :authenticate_user!, :except => :show
  before_filter :administrator!, :except => [:index, :show]
  
  # GET /pages
  # GET /pages.xml
  def index
    @pages = Page.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @page = Page.find_by_url(params[:id], :include => :children)
    @nav_context = @page.parent || @page
    @new_note = Note.new(:page_id => @page.id)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @page = Page.new
    @page.parent = Page.find_by_id(params[:parent_id])
    @page.page_banner = @page.parent.page_banner if @page.parent

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find_by_url(params[:id])
    @aspect = params[:aspect] || 'text'
    @new_photo = Photo.new(:page_id => @page.id) if 'photos' == @aspect
    @new_video = Video.new(:page_id => @page.id) if 'videos' == @aspect
    @new_contact = Contact.new(:page_id => @page.id) if 'contacts' == @aspect
    if 'events' == @aspect
      if params[:create] or @page.events.empty?
        @event = Event.new(:page_id => @page.id,
          :start_at => (Time.now.beginning_of_day + 1.day + 10.hour),
          :stop_at => (Time.now.beginning_of_day + 1.day + 11.hour))
      elsif params[:event_id]
        @event = Event.find(params[:event_id])
      elsif ! @page.events.empty?
        @event = @page.events.first
      end
    end
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
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
    @page.feature_image = nil if params[:delete_feature_image]
    @page.hero_background = nil if params[:delete_hero_background]

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

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find_by_url(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(pages_url) }
      format.xml  { head :ok }
    end
  end
end
