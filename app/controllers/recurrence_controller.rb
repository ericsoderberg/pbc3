class RecurrenceController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!
  
  def show
    @event = Event.find(params[:id])
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
    @event = Event.find(params[:id])
    params[:days] = [] unless params[:days]
    dates = params[:days].map{|day| Date.parse(day)}

    respond_to do |format|
      if @event.replicate(dates)
        format.html { redirect_to edit_page_url(@event.page,
          :aspect => 'events', :event_id => @event.id) }
        format.xml  { head :ok }
      else
        format.html { render :action => "show" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
