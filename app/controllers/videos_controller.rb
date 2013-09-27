class VideosController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_page
  before_filter :page_administrator!
  
  def index
    redirect_to new_page_video_url(@page)
  end

  def show
    @video = @page.videos.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @video }
    end
  end

  def new
    @video = Video.new(:page_id => @page.id)
  end

  def edit
    @video = @page.videos.find(params[:id])
  end

  def create
    @video = Video.new(video_params)
    @page = @video.page

    respond_to do |format|
      if @video.save
        format.html { redirect_to(new_page_video_url(@page),
          :notice => 'Video was successfully created.') }
        format.xml  { render :xml => @video, :status => :created, :location => @video }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @video = @page.videos.find(params[:id])

    respond_to do |format|
      if @video.update_attributes(video_params)
        format.html { redirect_to(new_page_video_url(@page),
          :notice => 'Video was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @video = @page.videos.find(params[:id])
    @video.destroy

    respond_to do |format|
      format.html { redirect_to(new_page_video_url(@page)) }
      format.xml  { head :ok }
      format.js
    end
  end
  
  private
  
  def video_params
    params.require(:video).merge(:updated_by => current_user).permit(:caption,
      :page_id, :youtube_id, :description, :vimeo_id, :video, :video2, :updated_by)
  end
  
end
