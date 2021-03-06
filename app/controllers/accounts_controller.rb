class AccountsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!, :except => [:edit, :update, :show]
  
  def index
    if current_user.administrator
      @users = User.order('last_name ASC, last_name IS NULL')
    else
      @users = [current_user]
    end
  end
  
  def show
    @user = User.find(params[:id])
    unless @user == current_user || current_user.administrator
      redirect_to root_url
      return
    end
    @pages = @user.pages.map{|p| {page: p}}
    @pages.each do |pageContext|
      page = pageContext[:page]
      pageContext[:color] = (page.style ? page.style.feature_color.to_s(16) : '#ccc')
      if page != @site.communities_page and page != @site.about_page
        pageContext[:events] = page.categorized_related_events()[:all]
=begin
        if current_user
          pageContext[:events][:all].each do |event|
            if page == event.page 
              pageContext[:invitation] =
                event.invitations.where(:email => current_user.email).first
            end
          end
        end
=end
      end
    end
  end
  
  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
    unless @user == current_user || current_user.administrator
      redirect_to root_url
      return
    end
  end
  
  def create
    @user = User.new(user_params)
    @user.password = SecureRandom.base64(12);
    @user.password_confirmation = @user.password
    @user.administrator = true unless @site and @site.id

    respond_to do |format|
      if @user.save
        format.html { redirect_to((@site and @site.id ? accounts_url : new_site_url),
          :notice => 'Account was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @user = User.find(params[:id])
    unless @user == current_user || current_user.administrator
      redirect_to root_url
      return
    end
    
    @user.avatar = nil if params[:delete_avatar]
    @user.portrait = nil if params[:delete_portrait]
    @user.administrator = true unless @site and @site.id

    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html {
          if current_user.administrator
            redirect_to(accounts_url, :notice => 'Account was successfully updated.')
          else
            redirect_to(root_url, :notice => 'Account was successfully updated.')
          end
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(accounts_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :administrator, :bio,
      :avatar, :portrait)
  end

end
