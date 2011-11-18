class UserMailer < ActionMailer::Base
  
  def contact_email(page, contact, message, from_name, from_email)
    @page = page
    @contact = contact
    @message = message
    @url = friendly_page_url(@page)
    @from_name = from_name
    @from_email = from_email
    mail(:to => @contact.user.email,
      :from => Site.first.email,
      :reply_to => @from_email,
      :subject => "#{@page.name} contact from #{@from_name}")
  end
  
end
