class EventsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_context
  layout "administration", only: [:new, :edit, :create, :update]

  def new
    @event = Event.new()
    if @page
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
    @message = "Editing #{@page.name} Page" if @page
  end

  def edit
    @event = Event.find(params[:id])
    @page_element = @page.page_elements.where('element_id = ?', @event.id).first if @page
    @pages = Page.editable(current_user).available_for_event(@event).sort()
    @message = (@event.page_elements.empty? ?
      "This event is not associated with any pages." :
      (@page ? "Editing #{@page.name} Page" : ""))
  end

  def create
    parse_times
    @event = Event.new(event_params)
    if @page
      @page_element = @page.page_elements.build({
        page: @page,
        element: @event,
        index: @page.page_elements.length + 1
      }.merge(page_element_params))
    end

    respond_to do |format|
      if @event.save and (! @page_element || @page_element.save)
        format.html { redirect_to(@context_url,
            :notice => 'Event was successfully created.') }
      else
        @pages = Page.editable(current_user).available_for_event(@event).sort()
        format.html { render :action => "new" }
      end
    end
  end

  def update
    parse_times
    @event = Event.find(params[:id])
    @page_element = @page.page_elements.where('element_id = ?', @event.id).first if @page
    update_method = 'Update all' == params[:commit] ?
      'update_with_replicas' : 'update_attributes'

    respond_to do |format|
      if @event.send(update_method, event_params) and
        (! @page_element || @page_element.update_attributes(page_element_params))
        format.html { redirect_to(@context_url,
            :notice => 'Event was successfully updated.') }
      else
        @pages = Page.editable(current_user).available_for_event(@event).sort()
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    if @page
      @page.normalize_indexes
    end

    respond_to do |format|
      format.html { redirect_to(@context_url) }
    end
  end

  private

  def get_context
    @page = Page.find(params[:page_id]) if params[:page_id]
    if @page
      @context_url = edit_contents_page_url(@page)
      @context_params = { page_id: @page.id }
    else
      @context_url = main_calendar_url()
      @context_params = {}
    end
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

  def page_element_params
    params.require(:page_element).permit(:full, :color)
  end

end
