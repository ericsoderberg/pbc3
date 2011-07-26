class EventsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!
  before_filter :get_page
  
  def index
    categorized_events = @page.categorized_events
    if categorized_events[:all].empty?
      redirect_to new_page_event_url(@page)
    else
      redirect_to edit_page_event_url(@page, categorized_events[:all].first)
    end
  end

  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  def new
    @event = Event.new(:page_id => @page.id)
    @event.start_at = (Time.now + 1.day).beginning_of_day + 10.hour
    @event.stop_at = @event.start_at + 1.hour
    @event.name = @page.name if @page.related_events.empty?
  end

  # GET /events/1/edit
  def edit
    @event = @page.events.find(params[:id])
  end
  
  def edit_page
    @page = Page.find(params[:id])
  end

  def create
    parse_times
    @event = Event.new(params[:event])
    @page = @event.page

    respond_to do |format|
      if @event.save
        format.html { redirect_to(edit_page_event_url(@page, @event),
            :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    parse_times
    @event = @page.events.find(params[:id])
    @page = @event.page
    params[:event][:page_id] = params[:choose_page_id] # due to flexbox
    update_method = 'Update all' == params[:commit] ?
      'update_with_replicas' : 'update_attributes'

    respond_to do |format|
      if @event.send(update_method, params[:event])
        format.html { redirect_to(new_page_event_url(@event.page),
            :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @event = @page.events.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(new_page_event_url(@page)) }
      format.xml  { head :ok }
    end
  end
  
  private

  def parse_times
    if params[:event][:start_at] and params[:event][:start_at].is_a?(String)
      params[:event][:start_at] =
        DateTime.parse_from_form(params[:event][:start_at])
    end
    if params[:event][:stop_at] and params[:event][:stop_at].is_a?(String)
      params[:event][:stop_at] =
        DateTime.parse_from_form(params[:event][:stop_at])
    end
  end
  
end
