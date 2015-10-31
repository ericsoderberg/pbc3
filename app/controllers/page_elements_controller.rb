class PageElementsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_page
  before_filter :page_administrator!
  layout "administration"

  def new
    @page_element = @page.page_elements.build()
    @pages = @page.possible_linked_pages()
  end

  def edit
    @page_element = PageElement.find(params[:id])
    @pages = @page.possible_linked_pages.to_a << @page_element.element
  end

  def create
    @page_element = @page.page_elements.build(page_element_params)
    @page_element.element = case @page_element.element_type
      when 'Page'
        Page
      when 'Event'
        Event
      end.find(@page_element.element_id)
    @page_element.index = @page.page_elements.length + 1

    respond_to do |format|
      if @page_element.save
        format.html { redirect_to(edit_contents_page_url(@page),
          :notice => 'Page Element was successfully created.') }
      else
        @pages = @page.possible_linked_pages()
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @page_element = PageElement.find(params[:id])

    respond_to do |format|
      if @page_element.update_attributes(page_element_params)
        format.html { redirect_to(edit_contents_page_url(@page),
          :notice => 'Page Element was successfully updated.') }
      else
        @pages = @page.possible_linked_pages()
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @page_element = PageElement.find(params[:id])
    @page_element.destroy
    @page.normalize_indexes

    respond_to do |format|
      format.html { redirect_to(edit_contents_page_url(@page)) }
    end
  end

  private

  def page_element_params
    params.require(:page_element).permit(:page_id, :element_id, :element_type)
  end

end
