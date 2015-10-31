class EventsController < ApplicationController
  before_filter :authenticate_user!
  layout "administration", only: [:new, :edit, :create, :update]

  def index
    redirect_to new_event_url(@page)
  end

=begin
  def search # DEPRECATED?
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
=end

  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  def new
    @event = Event.new()
    if params[:page_id]
      @page = Page.find(params[:page_id])
      @page_element = @event.page_elements.build({
        page: @page,
        element: @event,
        element_type: 'Event'
      })
      @event.name = @page.name
      @events = Event.masters.order('name ASC')
    end
    @event.start_at = (Time.now + 1.day).beginning_of_day + 10.hour
    @event.stop_at = @event.start_at + 1.hour
    @pages = Page.editable(current_user).available_for_event(@event).sort()
    @cancel_url = context_url(@page)
  end

  def edit
    @event = Event.find(params[:id])
    @page = @event.page
    @pages = Page.editable(current_user).available_for_event(@event).sort()
    @cancel_url = context_url(@page)
  end

  #def edit_page # DEPRECATED?
  #  @page = Page.find(params[:id])
  #end

  def create
    parse_times
    @event = Event.new(event_params)
    @page = Page.where(id: params[:page_id]).first
    if @page
      page_element = @page.page_elements.build({
        page: @page,
        element: @event,
        index: @page.page_elements.length + 1
      })
    end
    target_url = context_url(@page)

    respond_to do |format|
      if @event.save and (! page_element || page_element.save)
        format.html { redirect_to(target_url,
            :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        @pages = Page.editable(current_user).available_for_event(@event).sort()
        @cancel_url = context_url(@page)
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    parse_times
    @event = Event.find(params[:id])
    @prior_page = @event.page
    @page = Page.find(params[:page_id]) unless params[:page_id].empty?
    if @event.page and @event.page.id != params[:page_id]
      # user changed the page, remove all elements and re-associate with the new page
      @event.page_elements.clear
    end
    if @page and (not @event.page or @event.page != @page)
      page_element = @page.page_elements.build({
        page: @page,
        element: @event,
        index: @page.page_elements.length + 1
      })
    end
    update_method = 'Update all' == params[:commit] ?
      'update_with_replicas' : 'update_attributes'
    target_url = context_url(@prior_page) # go back where we came from

    respond_to do |format|
      if @event.send(update_method, event_params) and
        (! page_element || page_element.save)
        format.html { redirect_to(target_url,
            :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        @pages = Page.editable(current_user).available_for_event(@event).sort()
        @cancel_url = context_url(@prior_page)
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @page = @event.page
    target_url = context_url(@page)
    @event.destroy
    if @page
      @page.normalize_indexes
    end

    respond_to do |format|
      format.html { redirect_to(target_url) }
      format.xml  { head :ok }
    end
  end

  private

  def context_url(page)
    page ? edit_contents_page_url(page) : main_calendar_url()
  end

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
      :location, #:page_id,
      :master_id, :featured, :invitation_message, :notes,
      :updated_by, :global_name).merge(:updated_by => current_user)
  end

end
