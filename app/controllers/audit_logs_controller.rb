class AuditLogsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!
  
  # GET /audit_logs
  # GET /audit_logs.xml
  def index
    date = Date.today - 1.month
    @records = []
    [Page, Event, Message, Newsletter, Style, Audio, Video, Document, Form].each do |model|
      @records += model.where("updated_at > ?", date).order("updated_at DESC")
    end
    @records.sort!{|a, b| b.updated_at <=> a.updated_at}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @audit_logs }
    end
  end

  # GET /audit_logs/1
  # GET /audit_logs/1.xml
  def show
    @audit_log = AuditLog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @audit_log }
    end
  end
  
  def details
    @audit_log = AuditLog.find(params[:id])
    render :text => @audit_log.audited_changes
  end

  # GET /audit_logs/new
  # GET /audit_logs/new.xml
  def new
    @audit_log = AuditLog.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @audit_log }
    end
  end

  # GET /audit_logs/1/edit
  def edit
    @audit_log = AuditLog.find(params[:id])
  end

  # POST /audit_logs
  # POST /audit_logs.xml
  def create
    @audit_log = AuditLog.new(params[:audit_log])

    respond_to do |format|
      if @audit_log.save
        format.html { redirect_to(@audit_log, :notice => 'Audit log was successfully created.') }
        format.xml  { render :xml => @audit_log, :status => :created, :location => @audit_log }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @audit_log.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /audit_logs/1
  # PUT /audit_logs/1.xml
  def update
    @audit_log = AuditLog.find(params[:id])

    respond_to do |format|
      if @audit_log.update_attributes(params[:audit_log])
        format.html { redirect_to(@audit_log, :notice => 'Audit log was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @audit_log.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /audit_logs/1
  # DELETE /audit_logs/1.xml
  def destroy
    @audit_log = AuditLog.find(params[:id])
    @audit_log.destroy

    respond_to do |format|
      format.html { redirect_to(audit_logs_url) }
      format.xml  { head :ok }
    end
  end
end
