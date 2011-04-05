class AccountsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!, :except => [:edit, :update]
  
  def index
    if current_user.administrator
      @users = User.find(:all, :order => 'last_name, first_name')
    else
      @users = [current_user]
    end
  end

  def edit
    @user = User.find(params[:id])
    unless @user == current_user || current_user.administrator
      redirect_to root_url
      return
    end
  end
  
  def update
    @user = User.find(params[:id])
    unless @user == current_user || current_user.administrator
      redirect_to root_url
      return
    end
    
    params[:user][:first_name], params[:user][:last_name] =
      params[:user][:name].split(' ', 2)
    params[:user].delete(:name)
    @user.avatar = nil if params[:delete_avatar]

    respond_to do |format|
      if @user.update_attributes(params[:user])
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

end
