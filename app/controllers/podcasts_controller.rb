class PodcastsController < ApplicationController
  before_filter :authenticate_user!, :except => :show
  before_filter :administrator!, :except => :show
  before_filter :get_page
  
  # GET /podcasts
  # GET /podcasts.xml
  def index
    @podcasts = Podcast.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @podcasts }
    end
  end

  # GET /podcasts/1
  # GET /podcasts/1.xml
  def show
    @podcast = @page.podcast

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @podcast }
      format.rss { render :layout => false } #show.rss.builder
    end
  end

  # GET /podcasts/new
  # GET /podcasts/new.xml
  def new
    @podcast = Podcast.new(:page_id => @page.id)
    @podcast.category = 'Christianity'

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @podcast }
    end
  end

  # GET /podcasts/1/edit
  def edit
    @podcast = @page.podcast
  end

  # POST /podcasts
  # POST /podcasts.xml
  def create
    @podcast = Podcast.new(params[:podcast])
    @podcast.owner = User.find_by_email(params[:user_email])

    respond_to do |format|
      if @podcast.save
        format.html { redirect_to(friendly_page_url(@page),
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
    @podcast = @page.podcast
    owner = User.find_by_email(params[:user_email])
    params[:podcast][:user_id] = owner.id if owner

    respond_to do |format|
      if @podcast.update_attributes(params[:podcast])
        format.html { redirect_to(friendly_page_url(@page),
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
      format.html { redirect_to(friendly_page_url(@page)) }
      format.xml  { head :ok }
    end
  end
end
