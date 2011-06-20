class HyperHomeController < ApplicationController
  def index
    @photos = Photo.limit(6).all
    respond_to do |format|
      format.html
      format.pjs
      format.m4a {render :layout => false}
      format.mp3
    end
  end
end
