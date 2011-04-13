class RecurrenceController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!
  before_filter :get_page
  before_filter :get_event
  
  def show
    @date = @event.start_at
    @replicas = @event.replicas || []
    @calendar = Calendar.new(@event.start_at.beginning_of_month,
      (@event.start_at + 6.months).end_of_month);
    @calendar.populate(@replicas)

    respond_to do |format|
      format.html # replicas.html.erb
      format.xml  { render :xml => @event }
    end
  end

  def update
    params[:days] = [] unless params[:days]
    dates = params[:days].map{|day| Date.parse(day)}

    respond_to do |format|
      if @event.replicate(dates)
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
