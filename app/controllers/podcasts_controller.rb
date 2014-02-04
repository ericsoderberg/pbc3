class PodcastsController < ApplicationController
  before_filter :authenticate_user!, :except => :show
  before_filter :administrator!, :except => :show
  before_filter :get_page
  
  # GET /podcasts
  # GET /podcasts.xml
  def index
    @podcasts = Podcast.to_a

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @podcasts }
    end
  end

  # GET /podcasts/1
  # GET /podcasts/1.xml
  def show
    @podcast = (@page ? @page.podcast : @site.podcast)
    if @podcast
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @podcast }
        format.rss { render :layout => false } #show.rss.builder
      end
    elsif 'blog' == @page.layout
      respond_to do |format|
        format.rss { render :blog, :layout => false }
      end
    end
  end

  # GET /podcasts/new
  # GET /podcasts/new.xml
  def new
    @podcast = if @page
      Podcast.new(:page_id => @page.id)
    else
      Podcast.new(:site_id => @site.id)
    end
    @podcast.category = 'Religion & Spirituality'
    @podcast.sub_category = 'Christianity'

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @podcast }
    end
  end

  # GET /podcasts/1/edit
  def edit
    @podcast = (@page ? @page.podcast : @site.podcast)
  end

  # POST /podcasts
  # POST /podcasts.xml
  def create
    @podcast = Podcast.new(podcast_params)
    if @page
      @podcast.page = @page
    else
      @podcast.site = @site
    end
    @podcast.owner = User.find_by_email(params[:user_email])

    respond_to do |format|
      if @podcast.save
        format.html {
          redirect_to((@page ? friendly_page_url(@page) : pages_url),
            :notice => 'Podcast was successfully created.') }
        format.xml  { render :xml => @podcast, :status => :created, :location => @podcast }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @podcast.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /podcasts/1
  # PUT /podcasts/1.xml
  def update
    @podcast = (@page ? @page.podcast : @site.podcast)
    owner = User.find_by_email(params[:user_email])
    params[:podcast][:user_id] = owner.id if owner
    @podcast.image = nil if params[:delete_image]

    respond_to do |format|
      if @podcast.update_attributes(podcast_params)
        format.html {
          redirect_to((@page ? friendly_page_url(@page) : pages_url),
            :notice => 'Podcast was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @podcast.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /podcasts/1
  # DELETE /podcasts/1.xml
  def destroy
    @podcast = @page.podcast
    @podcast.destroy

    respond_to do |format|
      format.html { redirect_to((@page ? friendly_page_url(@page) : pages_url)) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def podcast_params
    params.require(:podcast).permit(:title, :subtitle, :summary, :description,
      :category, :page_id, :sub_category, :image, :user_id)
  end
  
end
