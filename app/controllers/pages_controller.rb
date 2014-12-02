class PagesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :feed]
  before_filter :administrator!,
    :except => [:show, :feed, :edit, :edit_style, :edit_email, :edit_email_members,
      :edit_access, :update, :new, :create, :destroy]
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
      session[:post_login_path] = request.original_url # needed?
      redirect_to private_path(:page_id => @page.url)
      return
    end
    if @page.url != params[:id]
      redirect_to friendly_page_url(@page)
      return
    end
    
    if (@page != @site.communities_page and @page != @site.about_page)
      events = @page.related_events
      events.delete_if{|e| not e.authorized?(current_user)}
      @categorized_events = Event.categorize(events)
      if current_user
        @categorized_events[:all].each do |event|
          if @page == event.page 
            @invitation =
              event.invitations.where(:email => current_user.email).first
          end
        end
      end
    end
    if @page.event?
      @event = @page.events.last
      @form = @page.forms.select{|f| f.published and f.visible?(current_user)}.first
    end
    if params[:invitation_key]
      @invitation = Invitation.find_by(key: params[:invitation_key])
    end
    @note = Note.new(:page_id => @page.id)
    
    @header_children = @page.nav_context.children.visible(current_user).
      where('pages.obscure != ? OR pages.id = ?', true, @page.id)
    
    @children = @page.children.visible(current_user).
      where('pages.obscure != ? OR pages.id = ?', true, @page.id)
    @feature_children = @page.feature_children(current_user)
    @aspects = @page.visible_aspects(:children => @children,
      :categorized_events => @categorized_events)
    if @page.parent and @page.parent.blog?
      @previous_page = @page.previous_sibling
      @next_page = @page.next_sibling
    end

    respond_to do |format|
      format.html { render :action => "show_#{@page.layout}" }
      format.xml  { render :xml => @page }
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
    @page.parent = Page.find_by(id: params[:parent_id])
    return unless page_administrator!(@page.parent)
    @page.text = ''
    @page.url_prefix = @page.parent.url if @page.parent
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
    @page = Page.find_by(url: params[:id])
    return unless page_administrator!
  end
  
  def edit_location
    @page = Page.find_by(url: params[:id])
    return unless page_administrator!
    @siblings = if @page.parent
        @page.parent.children
      elsif @page.site_primary?
        @site.primary_pages
      else
        []
      end
        
    impossible_parent_ids = (@page.descendants() + [@page]).map{|p| p.id}
    @pages = Page.editable(current_user).
      delete_if{|p| impossible_parent_ids.include?(p.id)}
  end
  
  def edit_style
    @page = Page.find_by(url: params[:id])
    return unless page_administrator!
  end
  
  def edit_email
    @page = Page.find_by(url: params[:id])
    return unless page_administrator!
    @email_list = EmailList.find(@page.email_list)
    @email_lists = EmailList.all
  end
  
  def edit_email_members
    @page = Page.find_by(url: params[:id])
    return unless page_administrator!
    @email_list = EmailList.find(@page.email_list)
    if not @email_list
      redirect_to edit_email_page_path(@page)
    end
  end
  
  def edit_access
    @page = Page.find_by(url: params[:id])
    return unless page_administrator!
  end
  
  def edit_for_parent
    page = Page.find_by(url: params[:id])
    parent = Page.find_by(id: params[:parent_id])
    siblings = parent.children.to_a
    siblings << page unless siblings.include?(page)
    siblings = siblings.to_a.map{|s| {id: s.id, name: s.name, url: s.url}}
    render :json => siblings
  end

  def create
    @page = Page.new(page_params)
    return unless page_administrator!(@page.parent)
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
    @page = Page.find_by(url: params[:id])
    return unless page_administrator!
    if params[:sub_order]
      orderer_sub_ids = params[:sub_order] ?
        params[:sub_order].split(',').map{|id| id.to_i} : []
      params[:page][:parent_index] = @page.id; # will be re-ordered late
    end
    if not current_user.administrator?
      # remove all fields that only administrators can change
      [:private, :home_feature, :parent_id,
        :allow_for_email_list, :any_user, :parent_feature].each do |property|
        params[:page].delete(property)
      end
    end

    respond_to do |format|
      if @page.update_attributes(page_params) and
        (not orderer_sub_ids or
          Page.order_children(orderer_sub_ids))
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
    @page = Page.find_by(url: params[:id])
    return unless page_administrator! and page_administrator!(@page.parent)
    parent = @page.parent
    @page.destroy
    # what about index and feature_index being shifted?

    respond_to do |format|
      format.html { redirect_to(parent ? friendly_page_url(parent) : pages_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def page_params
    params.require(:page).permit(:name, :text, :secondary_text,
      :parent_id, :private, :style_id,
      :parent_index, :layout, :email_list, :url_prefix, :animate_banner,
      :url_aliases, :obscure, :child_layout, :aspect_order, :facebook_url,
      :twitter_name, :banner_text,
      :updated_by, :site_primary).merge(:updated_by => current_user)
  end
  
end
