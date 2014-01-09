class SharedEventsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_page
  before_filter :page_administrator!
  before_filter :get_event
  
  def show
    @pages = Page.editable(current_user)
    
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def update
    @pages = Page.find(params[:page_ids] || [])

    respond_to do |format|
      begin
        if EventPage.share(@event, @pages,
          'Update for all' == params[:commit])
          format.html { redirect_to(edit_page_event_url(@page, @event),
            :notice => 'Shared pages were successfully updated.') }
          format.xml  { head :ok }
        else
          @pages = Page.order('name ASC')
          format.html { render :action => "show" }
        end
      rescue ActiveRecord::RecordInvalid => e
        @errors = e.message
        @pages = Page.order('name ASC')
        format.html { render :action => "show" }
      end
    end
  end
  
  private
  
  def get_event
    @event = @page.events.find(params[:event_id])
  end
  
end
