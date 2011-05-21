class InvitationMailer < ActionMailer::Base
  default :from => "from@example.com"
  
  def invitation_email(invitation, current_user)
    @invitation = invitation
    @event = @invitation.event
    @page = @event.page
    @inviter = current_user
    @url  = friendly_page_url(@page, :invitation_key => invitation.key)
    mail(:to => invitation.email,
      :from => Site.first.email,
      :subject => "Invitation to #{@event.name}")
  end
  
end
