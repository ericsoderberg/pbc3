class CalendarController < ApplicationController
  before_filter :get_context
  
  def month
    # start with first week having the first day of the referenced month
    # deal with beginning_of_week being Monday instead of Sunday
    @start_date =
      (@date.beginning_of_month + 1.day).beginning_of_week.yesterday
    @stop_date = @start_date + 5.weeks - 1.day
    @calendar = Calendar.new(@start_date, @stop_date)
    get_events
    @calendar.populate(@events)
  end

  def list
    @start_date = @date.beginning_of_month
    @stop_date = @start_date + 1.month - 1.day
    @full = params[:full] || false
    get_events
    @calendar = true
  end

  def day
    @start_date = @date.beginning_of_day
    @stop_date = @date.end_of_day
    @full = params[:full] || false
    get_events
    @calendar = true
  end
  
  private
  
  def get_context
    @date = params[:date] ? Time.parse(params[:date]) : Date.today
    @page = params[:page_id] ? Page.find_by_url(params[:page_id]) : nil
    @resource = params[:resource_id] ?
      Resource.find_by_id(params[:resource_id]) : nil
  end
  
  def get_events
    @events = if @full
        Event.between(@start_date, @stop_date).
          order("start_at ASC").all
      elsif @page
        @page.related_events(@start_date, @stop_date)
      elsif @resource
        @resource.events.between(@start_date, @stop_date)
      else
        Event.where('featured = ?', true).between(@start_date, @stop_date).
          order("start_at ASC").all
      end
  end

end
