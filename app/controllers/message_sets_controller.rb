class MessageSetsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :administrator!, :except => [:index, :show]
  
  # GET /message_sets
  # GET /message_sets.xml
  def index
    @message_sets = MessageSet.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @message_sets }
    end
  end

  # GET /message_sets/1
  # GET /message_sets/1.xml
  def show
    @message_set = MessageSet.find_by_url(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message_set }
    end
  end

  # GET /message_sets/new
  # GET /message_sets/new.xml
  def new
    @message_set = MessageSet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message_set }
    end
  end

  # GET /message_sets/1/edit
  def edit
    @message_set = MessageSet.find_by_url(params[:id])
  end

  # POST /message_sets
  # POST /message_sets.xml
  def create
    @message_set = MessageSet.new(params[:message_set])

    respond_to do |format|
      if @message_set.save
        format.html { redirect_to(series_path(@message_set),
          :notice => 'Message set was successfully created.') }
        format.xml  { render :xml => @message_set, :status => :created, :location => @message_set }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /message_sets/1
  # PUT /message_sets/1.xml
  def update
    @message_set = MessageSet.find_by_url(params[:id])

    respond_to do |format|
      if @message_set.update_attributes(params[:message_set])
        format.html { redirect_to(series_path(@message_set),
          :notice => 'Message set was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /message_sets/1
  # DELETE /message_sets/1.xml
  def destroy
    @message_set = MessageSet.find_by_url(params[:id])
    @message_set.destroy

    respond_to do |format|
      format.html { redirect_to(series_index_url) }
      format.xml  { head :ok }
    end
  end
end
