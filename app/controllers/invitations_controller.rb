class InvitationsController < ApplicationController
  before_filter :authenticate_user!, :except => :update
  before_filter :get_page
  before_filter :page_administrator!, :except => :update
  before_filter :get_event
   
  # GET /invitations
  # GET /invitations.xml
  def index
    @invitations = @event.invitations.to_a
    if @invitations.empty?
      redirect_to new_page_event_invitation_path(@page, @event)
      return
    end
    @summary = Invitation.summarize(@invitations)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invitations }
    end
  end
  
  def new
    if @event.invitations.empty? and @page.email_list
      @emails = @page.email_list + @site.email_domain
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invitations }
    end
  end
  
  def bulk_create
    invitations = []
    params[:emails].split(%r{[,:\n]}).each do |email|
      # see if this address is an email list
      name, domain = email.strip.split('@')
      email_list = nil
      if "@#{domain}" == @site.email_domain
        email_list = EmailList.find(name)
      end
      if email_list
        # invite everyone on the list
        email_list.addresses.each do |email|
          invitations << @event.invitations.new(:email => email.strip,
            :response => 'unknown')
        end
      else
        invitations << @event.invitations.new(:email => email.strip,
          :response => 'unknown')
      end
    end

    respond_to do |format|
      if @event.update_attributes(:invitation_message => params[:message]) and
        invitations.each{|i| i.save}
        invitations.each{|i| InvitationMailer.invitation_email(i, current_user).deliver}
        format.html { redirect_to(page_event_invitations_path(@page, @event),
          :notice => 'Invitation was successfully created.') }
        format.xml  { render :xml => @invitation, :status => :created, :location => @invitation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /invitations/1
  # PUT /invitations/1.xml
  def update
    @invitation = @event.invitations.find(params[:id])
    if @invitation.key != params[:invitation][:key]
      redirect_to friendly_page_url(@page)
      return
    end
    @initial_response = ('unknown' == @invitation.response)

    respond_to do |format|
      if @invitation.update_attributes(invitation_params)
        @summary = Invitation.summarize(@event.invitations)
        @heading = 'Response'
        @help_message = @initial_response ? 'Thanks for responding' :
          'Thanks for the update'
        format.html { redirect_to(
          friendly_page_url(@page, :invitation_key => @invitation.key),
          :notice => 'Invitation was successfully updated.') }
        format.xml  { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invitations/1
  # DELETE /invitations/1.xml
  def destroy
    @invitation = @event.invitations.find(params[:id])
    @invitation.destroy
    @summary = Invitation.summarize(@event.invitations)

    respond_to do |format|
      format.html { redirect_to(page_event_invitations_path(@page, @event)) }
      format.xml  { head :ok }
      format.js
    end
  end
  
  private
  
  def get_event
    @event = @page.events.find(params[:event_id])
  end
  
  def invitation_params
    params.require(:invitation).permit(:email, :key, :event_id, :response,
      :user_id, :note)
  end
  
end
