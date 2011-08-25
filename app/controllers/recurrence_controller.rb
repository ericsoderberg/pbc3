class RecurrenceController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_page
  before_filter :page_administrator!
  before_filter :get_event
  
  def show
    @date = @event.start_at
    peers = @event.peers
    @calendar = Calendar.new(@event.start_at - 1.month,
      (@event.start_at + 9.months).end_of_month);
    @calendar.populate(peers)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @event }
    end
  end

  def update
    params[:days] = [] unless params[:days]
    dates = params[:days].map{|day| Date.parse(day)}

    respond_to do |format|
      if (@event = @event.replicate(dates))
        format.html { redirect_to(edit_page_event_url(@page, @event),
          :notice => 'Recurrence was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "show" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  
  def get_event
    @event = @page.events.find(params[:event_id])
  end
  
end
