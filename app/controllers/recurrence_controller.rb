class RecurrenceController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_page
  before_filter :page_administrator!
  before_filter :get_event
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
        format.html { redirect_to(edit_event_url(@event),
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

  def get_event
    @event = Event.find(params[:event_id])
  end

  def get_calendar
    @date = @event.start_at
    peers = @event.peers.to_a
    @calendar = Calendar.new(@event.start_at - 1.month,
      (@event.start_at + 12.months).end_of_month);
    @calendar.populate(peers)
  end

end
