class HolidaysController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!

  layout "administration", only: [:new, :edit, :delete]

  def index
    @filter = {}
    @filter[:search] = params[:search]

    @holidays = Holiday
    if @filter[:search]
      @holidays = Holiday.search(@filter[:search])
    end
    @holidays = @holidays.order('date DESC')

    # get total count before we limit
    @count = @holidays.count

    if params[:offset]
      @holidays = @holidays.offset(params[:offset])
    end
    @holidays = @holidays.limit(20)

    @content_partial = 'holidays/index'

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :partial => "index" }
    end
  end

  def show
    @holiday = Holiday.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @holiday }
    end
  end

  def new
    @holiday = Holiday.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @holiday }
    end
  end

  def edit
    @holiday = Holiday.find(params[:id])
  end

  def create
    parse_date
    @holiday = Holiday.new(holiday_params)

    respond_to do |format|
      if @holiday.save
        format.html { redirect_to(holidays_url,
          :notice => 'Holiday was successfully created.') }
        format.xml  { render :xml => @holiday, :status => :created, :location => @holiday }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @holiday.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    parse_date
    @holiday = Holiday.find(params[:id])

    respond_to do |format|
      if @holiday.update_attributes(holiday_params)
        format.html { redirect_to(holidays_url,
          :notice => 'Holiday was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @holiday.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @holiday = Holiday.find(params[:id])
    @holiday.destroy

    respond_to do |format|
      format.html { redirect_to(holidays_url) }
      format.xml  { head :ok }
    end
  end

  private

  def parse_date
    if params[:holiday][:date] and params[:holiday][:date].is_a?(String)
      params[:holiday][:date] =
        Date.parse_from_form(params[:holiday][:date])
    end
  end

  def holiday_params
    params.require(:holiday).permit(:name, :date)
  end

end
