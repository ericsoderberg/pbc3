class AudiosController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_page
  before_filter :page_administrator!
  
  def index
    redirect_to new_page_audio_url(@page)
  end

  def show
    @audio = @page.audios.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @audio }
    end
  end

  def new
    @audio = Audio.new(:page_id => @page.id)
  end

  def edit
    @audio = @page.audios.find(params[:id])
  end

  def create
    parse_date
    @audio = Audio.new(audio_params)
    @page = @audio.page

    respond_to do |format|
      if @audio.save
        format.html { redirect_to(new_page_audio_url(@page),
          :notice => 'Audio was successfully created.') }
        format.xml  { render :xml => @audio, :status => :created, :location => @audio }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @audio.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    parse_date
    @audio = @page.audios.find(params[:id])

    respond_to do |format|
      if @audio.update_attributes(audio_params)
        format.html { redirect_to(new_page_audio_url(@page),
          :notice => 'Audio was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @audio.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @audio = @page.audios.find(params[:id])
    @audio.destroy

    respond_to do |format|
      format.html { redirect_to(new_page_audio_url(@page)) }
      format.xml  { head :ok }
    end
  end
  
  private

  def parse_date
    if params[:audio][:date] and params[:audio][:date].is_a?(String) and
      not params[:audio][:date].empty?
      params[:audio][:date] =
        Date.parse_from_form(params[:audio][:date])
    end
  end
  
  def audio_params
    params.require(:audio).merge(:updated_by => current_user).permit(:caption,
      :page_id, :date, :verses, :author, :event_id, :description, :audio, :audio2,
      :updated_by)
  end
  
end
