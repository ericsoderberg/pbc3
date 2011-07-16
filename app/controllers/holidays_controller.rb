class HolidaysController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!
  
  def index
    @holidays = Holiday.order('date ASC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @holidays }
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
    @holiday = Holiday.new(params[:holiday])

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
      if @holiday.update_attributes(params[:holiday])
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
  
end
