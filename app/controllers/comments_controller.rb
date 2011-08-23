class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_page
  before_filter :get_conversation
  
  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { render :partial => 'show' }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { render :partial => 'show' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { head :ok }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def get_conversation
    @conversation = @page.conversations.find(params[:conversation_id])
  end
  
end
