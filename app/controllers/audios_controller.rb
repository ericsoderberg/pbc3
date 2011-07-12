class AudiosController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!
  before_filter :get_page
  
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
    @audio = Audio.new(params[:audio])
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
    @audio = @page.audios.find(params[:id])

    respond_to do |format|
      if @audio.update_attributes(params[:audio])
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
end
