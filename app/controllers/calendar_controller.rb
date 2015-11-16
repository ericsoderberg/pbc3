class CalendarController < ApplicationController
  #before_filter :get_context

  def index
    @filter = {}
    @filter[:search] = params[:search] || ''

    # parse search
    tokens = Event.parse_query(@filter[:search])

    @events = Event

    # build query based on token score

    strong_tokens = tokens.select{|t| t[:score] > 0 and t[:clause]}
    weak_tokens = tokens.select{|t| t[:score] == 0 and t[:clause]}

    args = {}
    weak_clause = strong_clause = nil

    if not weak_tokens.empty?
      weak_clause = "(" + weak_tokens.map{|t| t[:clause]}.join(' OR ') + ")"
      weak_tokens.each{|t| args.merge!(t[:args])}
    end

    if not strong_tokens.empty?
      strong_clause = strong_tokens.map{|t| t[:clause]}.join(' AND ')
      strong_tokens.each{|t| args.merge!(t[:args])}
    end

    clause = if strong_clause
      if weak_clause
        "#{strong_clause} AND #{weak_clause}"
      else
        strong_clause
      end
    else
      weak_clause
    end

    @events = @events.includes(:resources)
    @events = @events.where(clause, args).references(:resources) if clause
    @events = @events.order('start_at ASC')

    range = tokens.select{|t| 'date' == t[:type]}.first[:range]
    @start_date = range[0]
    @stop_date = range[1]
    @calendar = Calendar.new(@start_date, @stop_date)
    @holidays = Holiday.where(:date => @start_date..@stop_date).order('date ASC').to_a
    @calendar.populate(@events.to_a, @holidays)

    # set up next and previous links
    delta = @stop_date.to_date - @start_date.to_date
    if delta <= 1
      @next = @stop_date.next_day.strftime("%B %d %Y")
      @previous = @start_date.prev_day.strftime("%B %d %Y")
    elsif delta <= 42
      @next = @stop_date.next_month.strftime("%B %Y")
      @previous = @start_date.prev_month.strftime("%B %Y")
    else
      @next = @stop_date.next_year.strftime("%Y")
      @previous = @start_date.prev_year.strftime("%Y")
    end

=begin
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
=end

    @content_partial = 'calendar/index'

    respond_to do |format|
      format.html { render :action => "index" }
      format.json { render :partial => "index" }
    end
  end

  def suggestions
    query = params[:q] || ''
    tokens = Event.parse_query(query)
    @suggestions = []

    dates = tokens.select{|t| 'date' == t[:type]}.map{|t| t[:matches]}.flatten.slice(0, 5)
    @suggestions << {label: 'Dates', suggestions: dates} unless dates.empty?
    events = tokens.select{|t| 'event' == t[:type]}.map{|t| t[:matches]}
    if not events.empty?
      names = events.first.limit(5).pluck('name', 'start_at').map {|a|
        a[0] + a[1].strftime(" %B %Y")}
      @suggestions << {label: 'Events', suggestions: names}
    end
    resources = tokens.select{|t| 'resource' == t[:type]}.map{|t| t[:matches]}
    if not resources.empty?
      names = resources.first.limit(5).pluck('name')
      @suggestions << {label: 'Resources', suggestions: names}
    end

    respond_to do |format|
      format.json { render :partial => "suggestions" }
    end
  end

=begin
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
=end

end
