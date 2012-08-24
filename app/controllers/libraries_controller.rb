class LibrariesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!

  def index
    @libraries = Library.order('name ASC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @libraries }
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
    @library = Library.new(params[:library])

    respond_to do |format|
      if @library.save
        format.html { redirect_to(libraries_url,
          :notice => 'Library was successfully created.') }
        format.xml  { render :xml => @library, :status => :created, :location => @library }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @library.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @library = Library.find(params[:id])

    respond_to do |format|
      if @library.update_attributes(params[:library])
        format.html { redirect_to(libraries_url,
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
end
