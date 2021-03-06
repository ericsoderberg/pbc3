class CalendarController < ApplicationController
  before_filter :get_context
  
  def index
    if mobile_device?
      redirect_to view_context.calendar_list_path(params)
    else
      redirect_to view_context.calendar_month_path(params)
    end
  end
  
  def month
    # start with first week having the first day of the referenced month
    # deal with beginning_of_week being Monday instead of Sunday
    @start_date =
      (@date.beginning_of_month + 1.day).beginning_of_week.yesterday
    @stop_date = (@start_date + @months.months).end_of_month.end_of_week.yesterday
    @calendar = Calendar.new(@start_date, @stop_date)
    get_events
    @holidays = Holiday.where(:date => @start_date..@stop_date).order('date ASC').to_a
    @calendar.populate(@events, @holidays)
    @isCurrent = (@date.beginning_of_month.to_date == Date.today.beginning_of_month)
  end

  def list
    @start_date = @date.beginning_of_month
    @stop_date = @start_date + @months.month - 1.day
    get_events
    @calendar = true
    @isCurrent = (@date.beginning_of_month.to_date == Date.today.beginning_of_month)
  end

  def day
    @start_date = @date.beginning_of_day
    @stop_date = @date.end_of_day
    get_events
    @calendar = true
    @isCurrent = (@date.to_date == Date.today)
  end
  
  private
  
  def get_context
    @date = params[:date] ? Time.parse(params[:date]) : Date.today
    @months = [(params[:months] ? params[:months].to_i : 1), 1].max
    @page = params[:page_id] ? Page.find_by(url: params[:page_id]) : nil
    @full = params[:full] || false
    @singular = params[:singular] || false
    @resource = params[:resource_id] ?
      Resource.find_by_id(params[:resource_id]) : nil
  end
  
  def get_events
    @events = if @full
        Event.between(@start_date, @stop_date.end_of_day).
          order("start_at ASC").to_a
      elsif @page
        @page.related_events(@start_date, @stop_date.end_of_day)
      elsif @resource
        @resource.events.between(@start_date, @stop_date.end_of_day).
          order("start_at ASC").to_a
      elsif current_user
        current_user.events(@start_date, @stop_date.end_of_day).to_a
      else
        Event.where('featured = ?', true).between(@start_date, @stop_date.end_of_day).
          order("start_at ASC").to_a
      end
    @events = @events.delete_if do |e|
      not e.authorized?(current_user) or (not @full and @singular and e.master)
    end
  end

end
