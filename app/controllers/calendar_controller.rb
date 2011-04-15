class CalendarController < ApplicationController
  
  def month
    @date = params[:date] ? Time.parse(params[:date]) : Date.today
    # start with first week having the first day of the referenced month
    # deal with beginning_of_week being Monday instead of Sunday
    start_day =
      (@date.beginning_of_month + 1.day).beginning_of_week.yesterday
    stop_day = start_day + 5.weeks - 1.day
    @calendar = Calendar.new(start_day, stop_day)
    @events = Event.between(start_day, stop_day).all
    @calendar.populate(@events)
  end

  def list
    @date = params[:date] ? Time.parse(params[:date]) : Date.today
    start_day = @date.beginning_of_month
    stop_day = start_day + 1.month - 1.day
    @events = Event.between(start_day, stop_day)
    @calendar = true
  end

  def day
  end

end
