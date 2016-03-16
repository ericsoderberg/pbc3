class LibrariesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!
  layout "administration", only: [:new, :edit, :destroy]

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

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @library }
    end
  end

  def edit
    @library = Library.find(params[:id])
  end

  def create
    @library = Library.new(library_params)

    respond_to do |format|
      if @library.save
        format.html { redirect_to(library_messages_url(@library),
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
        format.html { redirect_to(library_messages_url(@library),
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

    respond_to do |format|
      format.html { redirect_to(libraries_url) }
      format.xml  { head :ok }
    end
  end

  private

  def library_params
    params.require(:library).permit(:name)
  end

end
