class PagesController < ApplicationController
  before_filter :authenticate_user!, :except => :show
  before_filter :administrator!, :except => [:show]
  
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
    unless @page and @page.authorized?(current_user)
      redirect_to root_path
      return
    end
    
    @nav_context = @page.parent || @page
    @note = Note.new(:page_id => @page.id)

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
    @page.style = (@page.parent ? @page.style.page_banner : Style.first)

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
    @document = Document.new(:page_id => @page.id) if 'documents' == @aspect

    if 'contacts' == @aspect
      if params[:contact_id]
        @contact = @page.contacts.find(params[:contact_id])
      else
        @contact = Contact.new(:page_id => @page.id)
      end
    end

    @new_authorization = Authorization.new(:page_id => @page.id) if 'access' == @aspect

    if 'events' == @aspect
      @event_aspect = params[:event_aspect] || 'event'
      if params[:create] or @page.events.empty?
        ref = (Time.now + 1.day).beginning_of_day
        @event = Event.new(:page_id => @page.id,
          :start_at => (ref + 10.hour), :stop_at => (ref + 11.hour))
      elsif params[:event_id]
        @event = Event.find(params[:event_id])
      elsif ! @page.events.empty?
        @event = @page.events.first
      end

      if 'recurrence' == @event_aspect and @event
        @date = @event.start_at
        @replicas = @event.replicas || []
        @calendar = Calendar.new(@event.start_at.beginning_of_month,
          (@event.start_at + 6.months).end_of_month);
        @calendar.populate(@replicas)
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
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(pages_url) }
      format.xml  { head :ok }
    end
  end
end
