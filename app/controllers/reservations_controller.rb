class ReservationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!
  before_filter :get_page
  before_filter :get_event
  
  def show
    @resources = Resource.order('name ASC')
    @long = params[:long] || false
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reservation }
    end
  end

  def update
    @resources = Resource.find(params[:resources] || [])

    respond_to do |format|
      if Reservation.reserve(@event, @resources,
        'Update for all' == params[:commit],
        params[:options])
        format.html { redirect_to(edit_page_event_url(@page, @event),
          :notice => 'Reservations were successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reservation.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  
  def get_event
    @event = @page.events.find(params[:event_id])
  end
  
end
