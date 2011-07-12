class PhotosController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!
  before_filter :get_page
  
  def index
    redirect_to new_page_photo_url(@page)
  end

  def show
    @photo = @page.photos.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  def new
    @photo = Photo.new(:page_id => @page.id)
  end

  def edit
    @photo = @page.photos.find(params[:id])
  end

  def create
    @photo = Photo.new(params[:photo])
    @page = @photo.page

    respond_to do |format|
      if @photo.photo.content_type and @photo.save
        format.html { redirect_to(new_page_photo_url(@page),
          :notice => 'Photo was successfully created.') }
        format.xml  { render :xml => @photo, :status => :created, :location => @photo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @photo = @page.photos.find(params[:id])

    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        format.html { redirect_to(new_page_photo_url(@page),
          :notice => 'Photo was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @photo = @page.photos.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to(new_page_photo_url(@page)) }
      format.xml  { head :ok }
      format.js
    end
  end
end
