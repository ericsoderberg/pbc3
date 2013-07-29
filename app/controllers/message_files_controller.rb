class MessageFilesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :administrator!, :except => [:index, :show]
  before_filter :get_message
  
  # GET /message_files
  # GET /message_files.xml
  def index
    @message_files = @message.message_files.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @message_files }
    end
  end

  # GET /message_files/1
  # GET /message_files/1.xml
  def show
    @message_file = @message.message_files.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message_file }
    end
  end

  # GET /message_files/new
  # GET /message_files/new.xml
  def new
    @message_file = @message.message_files.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message_file }
    end
  end

  # GET /message_files/1/edit
  def edit
    @message_file = @message.message_files.find(params[:id])
  end

  # POST /message_files
  # POST /message_files.xml
  def create
    @message_file = @message.message_files.new(message_file_params)

    respond_to do |format|
      if @message_file.save
        format.html { redirect_to(edit_message_url(@message),
          :notice => 'Message file was successfully created.') }
        format.xml  { render :xml => @message_file, :status => :created, :location => @message_file }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /message_files/1
  # PUT /message_files/1.xml
  def update
    @message_file = @message.message_files.find(params[:id])

    respond_to do |format|
      if @message_file.update_attributes(message_file_params)
        format.html { redirect_to(edit_message_url(@message),
          :notice => 'Message file was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /message_files/1
  # DELETE /message_files/1.xml
  def destroy
    @message_file = @message.message_files.find(params[:id])
    @message_file.destroy

    respond_to do |format|
      format.html { redirect_to(edit_message_url(@message)) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def get_message
    @message = Message.find_by(url: params[:message_id])
  end
  
  def message_file_params
    params.require(:message_file).permit(:message_id, :caption, :vimeo_id,
      :youtube_id, :file)
  end
  
end
