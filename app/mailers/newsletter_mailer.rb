class NewsletterMailer < ActionMailer::Base
  
  helper EventsHelper
  
  def newsletter_email(newsletter, email)
    @newsletter = newsletter
    @title = @newsletter.name + ' - ' + @newsletter.published_at.relative_str(true)
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
    @header_css = ((@featured_page && @featured_page.style) ? @featured_page.style.css : '')
    @site = Site.first
    
    mail(:to => email,
      :from => @site.email,
      :subject => @title)
  end
  
end
