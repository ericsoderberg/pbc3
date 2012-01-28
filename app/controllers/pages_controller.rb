class PagesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :feed]
  before_filter :administrator!,
    :except => [:show, :feed, :edit, :edit_style, :edit_email, :update, :new, :create]
  # edit and update are handled inline below
  # new and create are handled inline and use the parent's' authorization
  
  def index
    @pages = Page.order("name ASC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
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
    @page = Page.find_by_url_or_alias(params[:id])
    unless @page
      redirect_to root_path
      return
    end
    unless @page.authorized?(current_user)
      redirect_to private_path(:page_id => @page.url)
      return
    end
    if @page.url != params[:id]
      redirect_to friendly_page_url(@page)
      return
    end
    
    if (@page != @site.communities_page and @page != @site.about_page)
      @categorized_events = Event.categorize(@page.related_events)
      if current_user
        @categorized_events[:all].each do |event|
          if @page == event.page 
            @invitation =
              event.invitations.where(:email => current_user.email).first
          end
        end
      end
    end
    if params[:invitation_key]
      @invitation = Invitation.find_by_key(params[:invitation_key])
    end
    @note = Note.new(:page_id => @page.id)
    
    @header_children = @page.nav_context.children.visible(current_user).
      where('pages.obscure != ? OR pages.id = ?', true, @page.id)
    
    @children = @page.children.visible(current_user).
      where('pages.obscure != ? OR pages.id = ?', true, @page.id)
    @feature_children = @page.feature_children(current_user)
    @aspects = @page.visible_aspects(:children => @children,
      :categorized_events => @categorized_events)

    respond_to do |format|
      format.html { render :action => "show_#{@page.layout}" }
      format.xml  { render :xml => @page }
    end
  end
  
  def feed
    @page = Page.find_by_url(params[:id], :include => :children)
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
    @page = Page.find_by_url(params[:id]);
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
    @page.parent = Page.find_by_id(params[:parent_id])
    return unless page_administrator!(@page.parent)
    @page.text = ''
    if current_user.administrator? and params[:site_page]
      @site_reference = params[:site_page]
      @page.name = @site_reference.capitalize
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end

  def edit
    @page = Page.find_by_url(params[:id])
    return unless page_administrator!
    @siblings = @page.parent ? @page.parent.children : []
  end
  
  def edit_style
    @page = Page.find_by_url(params[:id])
    return unless page_administrator!
  end
  
  def edit_email
    @page = Page.find_by_url(params[:id])
    return unless page_administrator!
    @email_list = EmailList.find(@page.email_list)
  end
  
  def edit_for_parent
    @page = Page.find_by_url(params[:id])
    @parent = Page.find_by_id(params[:parent_id])
    @siblings = @parent.children.all
    @siblings << @page unless @siblings.include?(@page)
    render :partial => 'edit_for_parent'
  end

  def create
    @page = Page.new(params[:page])
    return unless page_administrator!(@page.parent)
    #@page.parent_index = @page.parent ? @page.parent.children.length + 1 : 1
    if current_user.administrator? and params[:site_reference]
      @site.communities_page = @page if 'communities' == params[:site_reference]
      @site.about_page = @page if 'about' == params[:site_reference]
    end

    respond_to do |format|
      if @page.save and (not params[:site_reference] or @site.save)
        format.html { redirect_to(edit_page_path(@page),
          :notice => 'Page was successfully created.') }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @page = Page.find_by_url(params[:id])
    return unless page_administrator!
    if current_user.administrator? and params[:parent_id]
      params[:page][:parent_id] = params[:parent_id] # due to flexbox
    end
    if params[:email_list]
      params[:page][:email_list] = params[:email_list] # due to flexbox
    end
    if params[:sub_order]
      orderer_sub_ids = params[:sub_order] ?
        params[:sub_order].split(',').map{|id| id.to_i} : []
      params[:page][:parent_index] = -1; # will be re-ordered late
    end
    if not current_user.administrator?
      # remove all fields that only administrators can change
      [:private, :home_feature, :parent_id,
        :allow_for_email_list, :parent_feature].each do |property|
        params[:page].delete(property)
      end
    end

    respond_to do |format|
      if @page.update_attributes(params[:page]) and
        (not params[:parent_id] or
          not @page.parent or
          @page.parent.order_children(orderer_sub_ids))
        format.html { redirect_to(edit_page_path(@page), :notice => 'Page was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html {
          @siblings = @page.parent ? @page.parent.children : []
          @aspect = params[:aspect] || 'text'
          render :action => "edit"
        }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @page = Page.find_by_url(params[:id])
    parent = @page.parent
    @page.destroy
    # what about index and feature_index being shifted?

    respond_to do |format|
      format.html { redirect_to(parent ? friendly_page_url(parent) : pages_url) }
      format.xml  { head :ok }
    end
  end
  
end
