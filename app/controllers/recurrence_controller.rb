class RecurrenceController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_context
  before_filter :page_administrator!
  layout "administration"

  def edit
    get_calendar

    respond_to do |format|
      format.html
      format.xml  { render :xml => @event }
    end
  end

  def update
    params[:days] = [] unless params[:days]
    dates = params[:days].map{|day| Date.parse(day)}

    respond_to do |format|
      result = @event.replicate(dates)
      if (result and not result.is_a?(Array))
        @event = result
        format.html { redirect_to(@context_url,
          :notice => 'Recurrence was successfully updated.') }
        format.xml  { head :ok }
      else
        @save_errors = result
        @event.reload
        get_calendar
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  private

  def get_context
    @event = Event.find(params[:event_id])
    @page = Page.find(params[:page_id]) if params[:page_id]
    @context_url = @page ? edit_event_url(@event, :page_id => @page.id) :
      edit_event_url(@event)
  end

  def get_calendar
    @date = @event.start_at
    peers = @event.peers.to_a
    @calendar = Calendar.new(@event.start_at - 1.month,
      (@event.start_at + 12.months).end_of_month);
    @calendar.populate(peers)
  end

end
