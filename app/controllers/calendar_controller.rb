class CalendarController < ApplicationController
  before_filter :get_context
  
  def month
    # start with first week having the first day of the referenced month
    # deal with beginning_of_week being Monday instead of Sunday
    @start_date =
      (@date.beginning_of_month + 1.day).beginning_of_week.yesterday
    @stop_date = (@start_date + @months.months).end_of_month.end_of_week.yesterday
    @calendar = Calendar.new(@start_date, @stop_date)
    get_events
    @holidays = Holiday.where(:date => @start_date..@stop_date).order('date ASC')
    @calendar.populate(@events, @holidays)
  end

  def list
    @start_date = @date.beginning_of_month
    @stop_date = @start_date + @months.month - 1.day
    get_events
    @calendar = true
  end

  def day
    @start_date = @date.beginning_of_day
    @stop_date = @date.end_of_day
    get_events
    @calendar = true
  end
  
  private
  
  def get_context
    @date = params[:date] ? Time.parse(params[:date]) : Date.today
    @months = [(params[:months] ? params[:months].to_i : 1), 1].max
    @page = params[:page_id] ? Page.find_by_url(params[:page_id]) : nil
    @full = params[:full] || false
    @singular = params[:singular] || false
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
    @events = @events.delete_if do |e|
      not e.authorized?(current_user) or (@singular and e.master)
    end unless @full
  end

end
