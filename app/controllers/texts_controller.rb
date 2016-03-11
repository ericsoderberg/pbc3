class TextsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_page
  before_filter :page_administrator!
  layout "administration"

  def new
    @text = Text.new
    @page_element = @page.page_elements.new({ page: @page, element: @text })
    @title = "Add #{@page.name} Text"
    @message = "Editing #{@page.name} Page"
  end

  def edit
    @text = Text.find(params[:id])
    @page_element = @page.page_elements.where('element_id = ?', @text.id).first
    @message = "Editing #{@page.name} Page"
  end

  def create
    @text = Text.new(text_params)
    @page_element = @page.page_elements.build({
      page: @page,
      element: @text,
      index: @page.page_elements.length + 1
    }.merge(page_element_params))

    respond_to do |format|
      if @page_element.save
        format.html { redirect_to(edit_contents_page_url(@page),
          :notice => 'Text was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @text = Text.find(params[:id])
    @page_element = @page.page_elements.where('element_id = ?', @text.id).first

    respond_to do |format|
      if @text.update_attributes(text_params) and
        @page_element.update_attributes(page_element_params)
        format.html { redirect_to(edit_contents_page_url(@page),
          :notice => 'Text was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @text = Text.find(params[:id])
    @text.destroy
    @page.normalize_indexes

    respond_to do |format|
      format.html { redirect_to(edit_contents_page_url(@page), status: 303) }
      format.json { render :json => edit_contents_page_url(@page) }
    end
  end

  private

  def text_params
    params.require(:text).permit(:text)
  end

  def page_element_params
    params.require(:page_element).permit(:full, :color)
  end

end
