class LibrariesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!
  before_filter :get_context
  layout "administration", only: [:new, :edit, :create, :update, :destroy]

  def index
    @filter = {}
    @filter[:search] = params[:search]

    @libraries = Library
    if @filter[:search]
      @libraries = Library.search(@filter[:search])
    end
    @libraries = @libraries.order('LOWER(name) ASC')

    # get total count before we limit
    @count = @libraries.count

    if params[:offset]
      @libraries = @libraries.offset(params[:offset])
    end
    @libraries = @libraries.limit(20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :partial => "index" }
    end
  end

  def show
    @library = Library.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @library }
    end
  end

  def new
    @library = Library.new
    if @page
      @page_element = @library.page_elements.build({
        page: @page,
        element: @library,
        element_type: 'Library'
      })
      @library.name = @page.name
      @libraries = Library.order('name ASC')
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @library }
    end
  end

  def edit
    @library = Library.find(params[:id])
    if @page
      @page_element = @page.page_elements.where('element_id = ?', @library.id).first
    end
    @message = "Editing #{@page.name} Page" if @page
  end

  def create
    @library = Library.new(library_params)

    respond_to do |format|
      if @library.save
        format.html { redirect_to(@context_url,
          :notice => 'Library was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @library = Library.find(params[:id])

    respond_to do |format|
      if @library.update_attributes(library_params)
        format.html { redirect_to(@context_url,
          :notice => 'Library was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @library.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @library = Library.find(params[:id])
    @library.destroy
    if @page
      @page.normalize_indexes
    end
    @context_url = libraries_url() unless @page

    respond_to do |format|
      format.html { redirect_to(libraries_url) }
      format.xml  { head :ok }
    end
  end

  private

  def get_context
    @page = Page.find(params[:page_id]) if params[:page_id]
    if @page
      @context_url = edit_contents_page_url(@page)
      @context_params = { page_id: @page.id }
    else
      @context_url = (params[:id] ? library_messages_path(params[:id]) : libraries_url())
      @context_params = {}
    end
  end

  def library_params
    params.require(:library).permit(:name)
  end

end
