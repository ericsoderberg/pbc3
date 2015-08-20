class ItemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_page
  before_filter :page_administrator!
  layout "administration", only: [:new, :edit]

  def show
    @video = @page.videos.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @video }
    end
  end

  def new
    @item = Item.new
    @title = "Add #{@page.name} Item"
  end

  def edit
    @item = Item.find(params[:id])
    @title = "Edit #{@page.name} Item"
  end

  def create
    @item = Item.new(item_params)
    @page_element = @page.page_elements.build({
      page: @page,
      element: @item,
      index: @page.page_elements.length + 1
    })

    respond_to do |format|
      if @page_element.save
        format.html { redirect_to(edit_contents_page_url(@page),
          :notice => 'Item was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(item_params)
        format.html { redirect_to(edit_contents_page_url(@page),
          :notice => 'Item was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to(edit_contents_page_url(@page), status: 303) }
      format.json { render :json => edit_contents_page_url(@page) }
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :file, :url,
      :description, :date, :updated_by).merge(:updated_by => current_user)
  end

end
