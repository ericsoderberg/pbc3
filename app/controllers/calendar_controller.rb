class CalendarController < ApplicationController
  before_filter :get_page
  
  def month
    @date = params[:date] ? Time.parse(params[:date]) : Date.today
    # start with first week having the first day of the referenced month
    # deal with beginning_of_week being Monday instead of Sunday
    start_date =
      (@date.beginning_of_month + 1.day).beginning_of_week.yesterday
    stop_date = start_date + 5.weeks - 1.day
    @calendar = Calendar.new(start_date, stop_date)
    @events = if @page
      @page.related_events(start_date, stop_date)
    else
      Event.where('featured = ?', true).between(start_date, stop_date).order("start_at ASC").all
    end
    @calendar.populate(@events)
  end

  def list
    @date = params[:date] ? Time.parse(params[:date]) : Date.today
    start_day = @date.beginning_of_month
    stop_day = start_day + 1.month - 1.day
    @events = if @page
      @page.related_events(start_day, stop_day)
    else
      Event.where('featured = ?', true).between(start_day, stop_day).order("start_at ASC").all
    end
    @calendar = true
  end

  def day
  end
  
  private
  
  def get_page
    @page = params[:page_id] ? Page.find_by_url(params[:page_id]) : nil
  end

end
