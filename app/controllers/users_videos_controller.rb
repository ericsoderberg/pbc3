class UsersVideosController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_page
  before_filter :get_video

  def create
    @users_video = @video.users_videos.new(:user => current_user)
    
    respond_to do |format|
      if @users_video.save
        format.js { render :action => :get }
      else
        logger.info("Failed to save")
      end
    end
  end
  
  def destroy
    @users_video = @video.users_videos.find(params[:id])
    if @users_video.user_id == current_user.id
      @users_video.destroy
    end

    respond_to do |format|
      format.js { render :action => :get }
    end
  end
  
  private
  
  def get_video
    @video = @page.videos.find(params[:video_id])
  end
  
end
