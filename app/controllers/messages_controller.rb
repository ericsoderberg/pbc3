class MessagesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :administrator!, :except => [:index, :show]
  
  # GET /messages
  # GET /messages.xml
  def index
    @date = params[:date] ? params[:date].to_date : (Time.now + 3.months)
    @back_date = @date - 1.year
    @messages = Message.between_with_full_sets(@back_date, @date)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
      format.js
    end
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = Message.find_by_url(params[:id])
    @message = Message.find(params[:id]) unless @message

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    if params[:series_id]
      @message_set = MessageSet.find_by_url(params[:series_id])
      @message = @message_set.messages.new
      @message.author = @message_set.author
    else
      @message = Message.new
    end
    @message.date = Date.today

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find_by_url(params[:id])
    @message_file = @message.message_files.new
  end

  # POST /messages
  # POST /messages.xml
  def create
    @message = Message.new(params[:message])
    if params[:message_file]
      @message_file = @message.message_files.build(params[:message_file])
      @message_file.message = @message
    end

    respond_to do |format|
      if @message.save
        format.html { redirect_to((@message.message_set ?
          series_path(@message.message_set) : @message),
          :notice => 'Message was successfully created.') }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
    @message = Message.find_by_url(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to(@message, :notice => 'Message was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find_by_url(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to(messages_url) }
      format.xml  { head :ok }
    end
  end
  
end
