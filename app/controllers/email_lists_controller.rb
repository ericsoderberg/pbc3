class EmailListsController < ApplicationController
  before_filter :authenticate_user!, :except => [:add]
  before_filter :administrator!, :except => [:add, :update]
  before_filter :set_domain

  layout "administration", only: [:new, :edit, :subscribe, :unsubscribe]

  def index
    @filter = {}
    @filter[:search] = params[:search]

    @email_lists = if @filter[:search] and not @filter[:search].empty?
        @search = @filter[:search]
        EmailList.find_by_search(@search)
      else
        EmailList.all
      end

    @count = @email_lists.count

    @content_partial = 'email_lists/index'

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :partial => "index" }
    end
  end

  def search
    result_page_size = params[:s].to_i
    result_page = params[:p].to_i
    @email_lists = EmailList.find_by_search(params[:q] || '')
    total = @email_lists.count
    @email_lists =
      @email_lists[((result_page - 1) * result_page_size),result_page_size]

    respond_to do |format|
      format.js { render :json => {
        :results => @email_lists.map{|list| {:name => list.name}},
        :total => total}
      }
    end
  end

  def show
    @email_list = EmailList.find(params[:id])
    @filter = {}
    @filter[:search] = params[:search]

    @email_addresses = if @filter[:search] and not @filter[:search].empty?
        @search = @filter[:search]
        @email_list.search(@search)
      else
        @email_list.email_addresses
      end

    @count = @email_addresses.count

    @content_partial = 'email_lists/show'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :partial => "show" }
    end
  end

  def new
    @email_list = EmailList.new
  end

  def edit
    @email_list = EmailList.find(params[:id])
    # @pages = Page.where(:email_list => @email_list.name)
  end

  def create
    @email_list = EmailList.new(params[:email_list])

    respond_to do |format|
      if @email_list.save
        format.html { redirect_to(email_lists_url,
          :notice => 'Email list was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # def update
  #   @email_list = EmailList.find(params[:id])
  #   # add_addresses = params[:add_addresses].split
  #   # remove_addresses = params[:remove_addresses].split
  #   if params[:page_id]
  #     @page = Page.find(params[:page_id])
  #     return unless page_administrator!
  #   else
  #     return unless administrator!
  #   end
  #
  #   respond_to do |format|
  #     # if @email_list.remove_addresses(remove_addresses) and
  #     if @email_list.add_addresses(add_addresses, params[:invite])
  #       format.html { redirect_to(email_list_url(@email_list),
  #         :notice => 'Email list was successfully updated.') }
  #     else
  #       @pages = Page.where(:email_list => @email_list.name)
  #       format.html { render :action => "edit" }
  #     end
  #   end
  # end

  # def replace_address
  #   EmailList.replace_address(params[:old_address], params[:new_address])
  #   redirect_to(email_lists_url,
  #     :notice => "Replaced #{params[:old_address]} with #{params[:new_address]}")
  # end

  def subscribe
    @email_list = EmailList.find(params[:id])
    # @page = Page.find_by_email_list(@email_list.name)
  end

  def unsubscribe
    @email_list = EmailList.find(params[:id])
    # @page = Page.find_by_email_list(@email_list.name)
  end

  def add
    # if not params[:email_address_confirmation] or
    #   not params[:email_address_confirmation].empty?
    #   redirect_to root_path
    #   return
    # end
    @email_list = EmailList.find(params[:id])
    email_addresses = params[:email_addresses] ?
      params[:email_addresses].split :
      [params[:email_address]]
    # @page = Page.find_by_email_list(@email_list.name)
    @email_list.add_addresses(email_addresses, params[:invite])
    # redirect_to friendly_page_path(@page),
    #   :notice => "Subscribed #{params[:email_address]} to " +
    #     "#{@email_list.name}#{@site.email_domain}"
    redirect_to(email_list_url(@email_list),
      :notice => 'Subscribed to #{@email_list.name}#{@site.email_domain}.')
  end

  def remove
    @email_list = EmailList.find(params[:id])
    # @page = Page.find_by_email_list(@email_list.name)
    @email_list.remove_addresses([params[:email_address]])
    # redirect_to friendly_page_path(@page),
    #   :notice => "Unsubscribed from #{@email_list.name}"
    redirect_to(email_list_url(@email_list),
      :notice => 'Unsubscribed from #{@email_list.name}#{@site.email_domain}.')
  end

  def destroy
    @email_list = EmailList.find(params[:id])
    @email_list.destroy

    respond_to do |format|
      format.html { redirect_to(email_lists_url) }
    end
  end

  private

  # def adjust_addresses
  #   params[:email_list][:addresses] = params[:email_list][:addresses].split
  # end

  def set_domain
    EmailList.set_domain(@site.email_domain, @site.mailman_owner)
  end
end
