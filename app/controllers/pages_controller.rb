class PagesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :feed]
  before_filter :administrator!,
    :except => [:show, :feed, :edit, :edit_style, :edit_email, :edit_email_members,
      :edit_access, :update, :new, :create, :destroy]
  # edit and update are handled inline below
  # new and create are handled inline and use the parent's' authorization
  layout "administration", only: [:new, :create, :edit, :edit_context,
    :edit_access]

  def index
    @filter = {}
    @filter[:search] = params[:search]

    @pages = Page
    if @filter[:search]
      @pages = Page.search(@filter[:search])
    end
    @pages = @pages.order('LOWER(name) ASC')

    # get total count before we limit
    @count = @pages.count

    if params[:offset]
      @pages = @pages.offset(params[:offset])
    end
    @pages = @pages.limit(20)

    session[:breadcrumbs] = ''

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :partial => "index" }
    end
  end

  def search
    result_page_size = params[:s].to_i
    result_page = params[:p].to_i
    filtered_pages = Page.where("pages.name ILIKE ?", (params[:q] || '') + '%')
    if params[:date]
      date = Time.parse(params[:date])
      filtered_pages = filtered_pages.includes(:events).
        where('events.start_at >= ? AND events.stop_at <= ?',
          date.beginning_of_month, date.end_of_month)
    end
    ordered_pages = filtered_pages.order('pages.name ASC')
    @pages = ordered_pages.offset((result_page - 1) * result_page_size).
      limit(result_page_size)
    total = filtered_pages.count

    respond_to do |format|
      format.js { render :json => {:results =>
        @pages.map{|page| {:id => page.id, :name => page.prefixed_name, :url => page.url}},
        :total => total}
      }
    end
  end

  def show
    @page = Page.find_by_url_or_alias(params[:id] || @site.home_page_id)
    unless @page
      redirect_to root_path
      return
    end
    unless @page.authorized?(current_user)
      # session[:post_login_path] = request.original_url # needed?
      redirect_to private_path(:page_id => @page.url)
      return
    end
    if @page.url != params[:id]
      redirect_to friendly_page_url(@page)
      return
    end

    # Page breadcrumbs. Only do this for pages as everything else anchors to
    # a page.
    breadcrumbs = (session[:breadcrumbs] || '').split('|')
    if breadcrumbs.length > 1 and breadcrumbs[-2].to_i == @page.id
      # user has gone back, prune breadcrumbs
      breadcrumbs.pop
    elsif breadcrumbs.length > 0 and breadcrumbs[-1].to_i == @page.id
      # user has refreshed, no change
    else
      breadcrumbs.push(@page.id)
    end
    session[:breadcrumbs] = breadcrumbs.join('|')
    if breadcrumbs.length > 1
      @back_page = Page.find(breadcrumbs[-2].to_i)
    end

    if @page.administrator? current_user
      @edit_url = edit_contents_page_url(@page, :protocol => 'https')
    end

    respond_to do |format|
      format.html { render :action => "show" }
      format.json { render :partial => "show" }
    end
  end

  def feed
    @page = Page.find_by(url: params[:id]).includes(:children)
    unless @page and @page.authorized?(current_user)
      redirect_to root_path
      return
    end
    @pages = @page.children.order("updated_at DESC").limit(20)

    respond_to do |format|
      format.html
      format.rss { render :layout => false } #feed.rss.builder
    end
  end

  def search_possible_parents
    @page = Page.find_by(url: params[:id]);
    all_pages = @page.possible_parents
    # prune for search
    search_text = params[:q]
    matched_pages = if search_text and not search_text.empty?
        all_pages.select{|page| page.name =~ /^#{search_text}/i}
      else
        all_pages
      end
    # limit amount
    result_page_size = params[:s].to_i
    result_page = params[:p].to_i
    limited_pages =
      matched_pages[(result_page - 1) * result_page_size, result_page_size]

    respond_to do |format|
      format.js { render :json => {:results =>
        limited_pages.map{|page| {:id => page.id, :name => page.name}},
        :total => matched_pages.length}
      }
    end
  end

  def new
    @page = Page.new
    @email_lists = EmailList.all

    respond_to do |format|
      format.html
    end
  end

  def edit
    @page = Page.find_by(url: params[:id])
    return unless page_administrator!
    @email_lists = EmailList.all

    respond_to do |format|
      format.html
    end
  end

  def edit_contents
    @page = Page.find_by(url: params[:id])
    return unless page_administrator!

    @add_menu_actions = [
      {label: 'Text', url: new_page_text_path(@page)},
      {label: 'File/Url', url: new_page_item_path(@page)},
      {label: 'Page', url: new_page_element_path(@page)},
      {label: 'Form', url: new_form_path(:page_id => @page.id)},
      {label: 'Library', url: new_library_path(:page_id => @page.id)},
      {label: 'Event', url: new_event_path(:page_id => @page.id)}
    ]

    respond_to do |format|
      format.html { render :action => "edit_contents", :layout => 'admin' }
      format.json { render :partial => "edit_contents" }
    end
  end

  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to(edit_contents_page_path(@page),
          :notice => 'Page was successfully created.') }
      else
        @email_lists = EmailList.all
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @page = Page.find_by(url: params[:id])
    return unless page_administrator!
    if not current_user.administrator?
      # remove all fields that only administrators can change
      [:private, :home_feature, :parent_id,
        :allow_for_email_list, :any_user, :parent_feature].each do |property|
        params[:page].delete(property)
      end
    end

    respond_to do |format|
      if @page.update_attributes(page_params)
        format.html { redirect_to(friendly_page_path(@page), :notice => 'Page was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def update_contents_order
    @page = Page.find_by(url: params[:id])
    return unless page_administrator!

    respond_to do |format|
      if @page.order_elements(params[:element_order])
        format.html { redirect_to(friendly_page_path(@page),
          :notice => 'Page was successfully updated.') }
        format.json { render :json => {result: 'ok',
          redirect_to: friendly_page_path(@page)} }
      else
        format.html {
          render :action => "edit_contents", :layout => "administration"
        }
        format.json { render :json => 'error' }
      end
    end
  end

  def destroy
    @page = Page.find_by(url: params[:id])
    return unless page_administrator!
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(pages_url) }
    end
  end

  private

  def page_params
    params.require(:page).permit(:name, :private, :obscure,
      :url_prefix, :url_aliases, :facebook_url, :twitter_name, :email_list,
      :updated_by, :parent_id).merge(:updated_by => current_user)
  end

end
