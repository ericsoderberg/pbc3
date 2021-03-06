class DocumentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_page
  before_filter :page_administrator!
  
  def index
    @documents = @page.documents
    redirect_to new_page_document_url(@page)
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
    @pages = Page.editable(current_user)
  end

  def create
    parse_date
    @document = Document.new(document_params)
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
    parse_date
    @document = @page.documents.find(params[:id])
    @page = @document.page

    respond_to do |format|
      if @document.update_attributes(document_params)
        format.html { redirect_to(new_page_document_url(@document.page),
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
  
  private
  
  def parse_date
    if params[:document][:published_at] and
      not params[:document][:published_at].empty?
      params[:document][:published_at].is_a?(String)
      params[:document][:published_at] =
        Date.parse_from_form(params[:document][:published_at])
    else
      params[:document][:published_at] = nil
    end
  end
  
  def document_params
    params.require(:document).permit(:page_id, :name, :summary, :published_at,
      :file, :updated_by).merge(:updated_by => current_user)
  end
  
end
