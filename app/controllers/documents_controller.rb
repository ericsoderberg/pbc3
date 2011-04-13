class DocumentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!
  before_filter :get_page
  
  def index
    @documents = @page.documents
    if @documents.empty?
      redirect_to new_page_document_url(@page)
    else
      redirect_to edit_page_document_url(@page, @documents.first)
    end
  end

  def show
    @document = Document.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @document }
    end
  end

  def new
    @document = Document.new(:page_id => @page.id)
  end

  def edit
    @document = @page.documents.find(params[:id])
  end

  def create
    @document = Document.new(params[:document])
    @page = @document.page

    respond_to do |format|
      if @document.save
        format.html { redirect_to(new_page_document_url(@page),
          :notice => 'Document was successfully created.') }
        format.xml  { render :xml => @document, :status => :created, :location => @document }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @document.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @document = @page.documents.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:document])
        format.html { redirect_to(new_page_document_url(@page),
          :notice => 'Document was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @document.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @document = @page.documents.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to(new_page_document_url(@page)) }
      format.xml  { head :ok }
    end
  end
end
