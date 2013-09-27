class NewslettersController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :administrator!, :except => [:index, :show]
  
  def index
    @newsletters = Newsletter.order('published_at DESC')

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @newsletter = Newsletter.find_by_published_at(params[:id])
    @title = @newsletter.name + ' - ' +
      @newsletter.published_at.relative_str(true)
    @previous_newsletter = @newsletter.previous
    @next_newsletter = @newsletter.next
    @featured_page = @newsletter.featured_page
    @featured_event = @newsletter.featured_event
    if @featured_event and not @featured_page
      @featured_page = @featured_event.page
    end
    @next_message = @newsletter.next_message
    @previous_message = @newsletter.previous_message
    @focus_messages = ((not @newsletter.note or @newsletter.note.empty?) and not @featured_page)
    @header_css = ((@featured_page && @featured_page.style) ? @featured_page.style.css : 'background-color: #666;')
    @mode = params[:mode] || 'html'
    @route_prefix = request.protocol + request.host_with_port

    respond_to do |format|
      format.html { render :layout => "newsletter" }
    end
  end

  def new
    @newsletter = Newsletter.new
    @newsletter.published_at = Date.today
    @events = Event.between(Date.yesterday, Date.today + 1.month)

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @newsletter = Newsletter.find_by_published_at(params[:id])
    @events = Event.between(Date.yesterday, Date.today + 1.month)
  end

  def create
    cleanup_params
    @newsletter = Newsletter.new(newsletter_params)

    respond_to do |format|
      if @newsletter.save
        format.html { redirect_to(newsletter_url(@newsletter),
          :notice => 'Newsletter was successfully created.') }
      else
        @events = Event.between(Date.yesterday, Date.today + 1.month)
        format.html { render :action => "new" }
      end
    end
  end

  def update
    cleanup_params
    @newsletter = Newsletter.find_by_published_at(params[:id])

    respond_to do |format|
      if @newsletter.update_attributes(newsletter_params)
        format.html { redirect_to(newsletter_url(@newsletter),
          :notice => 'Newsletter was successfully updated.') }
      else
        @events = Event.between(Date.yesterday, Date.today + 1.month)
        format.html { render :action => "edit" }
      end
    end
  end
  
  def deliver
    @newsletter = Newsletter.find_by_published_at(params[:id])
    @email = params[:email]
    @route_prefix = request.protocol + request.host_with_port
    NewsletterMailer.newsletter_email(@newsletter, @email, @route_prefix).deliver
    @newsletter.sent_to = @email
    @newsletter.sent_at = Time.now
    @newsletter.save
    redirect_to(newsletter_url(@newsletter),
      :notice => 'Newsletter was successfully sent.')
  end

  def destroy
    @newsletter = Newsletter.find_by_published_at(params[:id])
    @newsletter.destroy

    respond_to do |format|
      format.html { redirect_to(newsletters_url) }
    end
  end
  
  private
  
  def cleanup_params
    if params[:newsletter][:published_at] and
      params[:newsletter][:published_at].is_a?(String)
      params[:newsletter][:published_at] =
        Date.parse_from_form(params[:newsletter][:published_at])
    end
    if params[:choose_event_id] and
      not params[:choose_event_id].empty?
      params[:newsletter][:featured_event_id] = params[:choose_event_id] # due to flexbox
    end
    if params[:choose_page_id] and
      not params[:choose_page_id].empty?
      params[:newsletter][:featured_page_id] = params[:choose_page_id] # due to flexbox
    end
    if params[:choose_email_list] and
      not params[:choose_email_list].empty?
      params[:newsletter][:email_list] = params[:choose_email_list] # due to flexbox
    end
  end
  
  def newsletter_params
    params.require(:newsletter).merge(:updated_by => current_user.id).permit(:name,
      :email_list, :published_at, :featured_page_id, :featured_event_id, :note,
      :window)
  end
  
end
