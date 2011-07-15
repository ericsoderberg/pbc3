class EmailListsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!
  
  def index
    @email_lists = if params[:search] and not params[:search].empty?
        @search = params[:search]
        EmailList.find_by_address(@search)
      else
        EmailList.all
      end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @email_lists }
    end
  end

  def show
    @email_list = EmailList.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @email_list }
    end
  end

  def new
    @email_list = EmailList.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @email_list }
    end
  end

  def edit
    @email_list = EmailList.find(params[:id])
  end

  def create
    params[:email_list][:addresses] = params[:email_list][:addresses].split
    @email_list = EmailList.new(params[:email_list])

    respond_to do |format|
      if @email_list.save
        format.html { redirect_to(email_lists_url,
          :notice => 'Email list was successfully created.') }
        format.xml  { render :xml => @email_list, :status => :created, :location => @email_list }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @email_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @email_list = EmailList.find(params[:id])
    add_addresses = params[:add_addresses].split
    remove_addresses = params[:remove_addresses].split

    respond_to do |format|
      if @email_list.update_attributes(params[:email_list]) and
        @email_list.remove_addresses(remove_addresses) and
        @email_list.add_addresses(add_addresses)
        format.html { redirect_to(email_lists_url,
          :notice => 'Email list was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @email_list.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def replace_address
    EmailList.replace_address(params[:old_address], params[:new_address])
    redirect_to(email_lists_url,
      :notice => "Replaced #{params[:old_address]} with #{params[:new_address]}")
  end

  def destroy
    @email_list = EmailList.find(params[:id])
    @email_list.destroy

    respond_to do |format|
      format.html { redirect_to(email_lists_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def adjust_addresses
    params[:email_list][:addresses] = params[:email_list][:addresses].split
  end
end
