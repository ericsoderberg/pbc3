class ConversationsController < ApplicationController
  before_filter :authenticate_user!, :except => [:email, :send_email]
  before_filter :get_page
  
  def index
    @conversations = @page.conversations

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @conversations }
    end
  end

  def show
    @conversation = @page.conversations.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @conversation }
    end
  end

  def new
    @conversation = @page.conversations.new
    @conversation.text = '<p>please edit</p>'

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @conversation }
    end
  end

  def edit
    @conversation = @page.conversations.find(params[:id])
  end

  def create
    @conversation = @page.conversations.new(params[:conversation])
    @conversation.user = current_user

    respond_to do |format|
      if @conversation.save
        format.html { redirect_to(friendly_page_path(@page),
          :notice => 'Conversation was successfully started.') }
        format.xml  { render :xml => @conversation, :status => :created, :location => @conversation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @conversation.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @conversation = @page.conversations.find(params[:id])

    respond_to do |format|
      if @conversation.update_attributes(params[:conversation])
        format.html { redirect_to(friendly_page_path(@page),
          :notice => 'Conversation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @conversation.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @conversation = @page.conversations.find(params[:id])
    @conversation.destroy

    respond_to do |format|
      format.html { redirect_to(friendly_page_url(@page)) }
      format.xml  { head :ok }
    end
  end
end
