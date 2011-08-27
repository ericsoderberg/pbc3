class ContactsController < ApplicationController
  before_filter :authenticate_user!, :except => [:email, :send_email]
  before_filter :get_page
  before_filter :page_administrator!, :except => [:email, :send_email]
  
  def index
    redirect_to new_page_contact_url(@page)
  end

  def show
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  def new
    @contact = Contact.new(:page_id => @page.id)
  end

  def edit
    @contact = @page.contacts.find(params[:id])
  end

  def create
    @contact = Contact.new(params[:contact])
    @page = @contact.page
    @contact.user = User.find_by_email(params[:user_email])

    respond_to do |format|
      if @contact.save
        format.html { redirect_to(new_page_contact_url(@page),
          :notice => 'Contact was successfully created.') }
        format.xml  { render :xml => @contact, :status => :created, :location => @contact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @contact = @page.contacts.find(params[:id])
    @contact.portrait = nil if params[:delete_portrait]

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to(new_page_contact_url(@page),
          :notice => 'Contact was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def email
    @contact = @page.contacts.find(params[:id])
  end
  
  def send_email
    @contact = @page.contacts.find(params[:id])
    UserMailer.contact_email(@page, @contact, params[:message],
      params[:name], params[:email_address]).deliver
    redirect_to friendly_page_url(@page), :notice => 'Email sent'
  end

  def destroy
    @contact = @page.contacts.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(new_page_contact_url(@page)) }
      format.xml  { head :ok }
    end
  end
end
