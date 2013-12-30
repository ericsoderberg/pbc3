class EventsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_page, :except => :search
  before_filter :page_administrator!
  
  def index
    redirect_to new_page_event_url(@page)
  end
  
  def search
    result_page_size = params[:s].to_i
    result_page = params[:p].to_i
    filtered_events = Event.where("events.name ILIKE ?", (params[:q] || '') + '%')
    if params[:date]
      date = Time.parse(params[:date])
      filtered_events = filtered_events.
        where('events.start_at >= ? AND events.stop_at <= ?',
          date, date + 1.month)
    end
    ordered_events = filtered_events.order('events.name ASC')
    @events = ordered_events.offset((result_page - 1) * result_page_size).
      limit(result_page_size)
    total = filtered_events.count
    
    respond_to do |format|
      format.js { render :json => {:results =>
        @events.map{|event| {:id => event.id, :name => event.name, :url => friendly_page_url(event.page)}},
        :total => total}
      }
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
    @pages = Page.editable(current_user)
  end
  
  def edit_page
    @page = Page.find(params[:id])
  end

  def create
    parse_times
    @event = Event.new(event_params)
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
    update_method = 'Update all' == params[:commit] ?
      'update_with_replicas' : 'update_attributes'

    respond_to do |format|
      if @event.send(update_method, event_params)
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
  
  def event_params
    params.require(:event).permit(:name, :start_at, :stop_at, :all_day,
      :location, :page_id, :master_id, :featured, :invitation_message, :notes,
      :updated_by).merge(:updated_by => current_user)
  end
  
end
