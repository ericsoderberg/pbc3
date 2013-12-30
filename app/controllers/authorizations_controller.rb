class AuthorizationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_page
  before_filter :page_administrator!
  
  def index
    redirect_to new_page_authorization_url(@page)
  end

  def show
    @authorization = @page.authorizations.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @authorization }
    end
  end

  def new
    @authorization = Authorization.new(:page_id => @page.id)
  end

  def edit
    @authorization = @page.authorizations.find(params[:id])
  end

  def create
    @authorization = Authorization.new(authorization_params)
    @page = @authorization.page
    @authorization.user = User.find_by_email(params[:user_email])

    respond_to do |format|
      if @authorization.save
        format.html { redirect_to(new_page_authorization_url(@page),
            :notice => 'Authorization was successfully created.') }
        format.xml  { render :xml => @authorization, :status => :created, :location => @authorization }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @authorization.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @authorization = @page.authorizations.find(params[:id])

    respond_to do |format|
      if @authorization.update_attributes(authorization_params)
        format.html { redirect_to(new_page_authorization_url(@page),
          :notice => 'Authorization was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @authorization.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @authorization = @page.authorizations.find(params[:id])
    @authorization.destroy

    respond_to do |format|
      format.html { redirect_to(new_page_authorization_url(@page)) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def authorization_params
    params.require(:authorization).permit(:page_id, :user_id, :administrator)
  end
  
end
