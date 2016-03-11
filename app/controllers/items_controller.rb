class ItemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_page
  before_filter :page_administrator!
  layout "administration"

  def new
    @item = Item.new
    @page_element = @page.page_elements.new({ page: @page, element: @item })
    @title = "Add #{@page.name} Item"
    @message = "Editing #{@page.name} Page"
  end

  def edit
    @item = Item.find(params[:id])
    @page_element = @page.page_elements.where('element_id = ?', @item.id).first
    @title = "Edit #{@page.name} Item"
    @message = "Editing #{@page.name} Page"
  end

  def create
    @item = Item.new(item_params)
    @page_element = @page.page_elements.build({
      page: @page,
      element: @item,
      index: @page.page_elements.length + 1
    }.merge(page_element_params))

    respond_to do |format|
      if @page_element.save
        format.html { redirect_to(edit_contents_page_url(@page),
          :notice => 'Item was successfully created.') }
      else
        @message = "Editing #{@page.name} Page"
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @item = Item.find(params[:id])
    @page_element = @page.page_elements.where('element_id = ?', @item.id).first

    respond_to do |format|
      if @item.update_attributes(item_params) and
        @page_element.update_attributes(page_element_params)
        format.html { redirect_to(edit_contents_page_url(@page),
          :notice => 'Item was successfully updated.') }
      else
        @message = "Editing #{@page.name} Page"
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    @page.normalize_indexes

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

  def page_element_params
    params.require(:page_element).permit(:full, :color)
  end

end
