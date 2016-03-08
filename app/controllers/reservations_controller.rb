class ReservationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_context
  before_filter :page_administrator!
  layout "administration"

  def edit
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
      begin
        if Reservation.reserve(@event, @resources,
          params[:all_dates], params[:options])
          format.html { redirect_to(@context_url,
            :notice => 'Reservations were successfully updated.') }
          format.xml  { head :ok }
        else
          @resources = Resource.order('name ASC')
          @long = params[:long] || false
          format.html { render :action => "edit" }
          format.xml  { render :xml => @reservation.errors, :status => :unprocessable_entity }
        end
      rescue ActiveRecord::RecordInvalid => e
        @errors = e.message
        @resources = Resource.order('name ASC')
        @long = params[:long] || false
        format.html { render :action => "edit" }
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

end
