class ResourcesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!

  layout "administration", only: [:new, :edit, :delete]

  def index
    @filter = {}
    @filter[:search] = params[:search]

    @resources = Resource
    if @filter[:search]
      @resources = Resource.search(@filter[:search])
    end
    @resources = @resources.order('LOWER(name) ASC')

    # get total count before we limit
    @count = @resources.count

    if params[:offset]
      @resources = @resources.offset(params[:offset])
    end
    @resources = @resources.limit(20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :partial => "index" }
    end
  end

  # GET /resources/1
  # GET /resources/1.xml
  def show
    @resource = Resource.find(params[:id])
    @events = @resource.events.order('start_at DESC')

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /resources/new
  # GET /resources/new.xml
  def new
    @resource = Resource.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /resources/1/edit
  def edit
    @resource = Resource.find(params[:id])
  end

  # POST /resources
  # POST /resources.xml
  def create
    @resource = Resource.new(resource_params)

    respond_to do |format|
      if @resource.save
        format.html { redirect_to(resources_url,
          :notice => 'Resource was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /resources/1
  # PUT /resources/1.xml
  def update
    @resource = Resource.find(params[:id])

    respond_to do |format|
      if @resource.update_attributes(resource_params)
        format.html { redirect_to(resources_url,
          :notice => 'Resource was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def delete
    @resource = Resource.find(params[:id])
  end

  # DELETE /resources/1
  # DELETE /resources/1.xml
  def destroy
    @resource = Resource.find(params[:id])
    @resource.destroy

    respond_to do |format|
      format.html { redirect_to(resources_url) }
      format.xml  { head :ok }
    end
  end

  private

  def resource_params
    params.require(:resource).permit(:name, :resource_type)
  end

end
