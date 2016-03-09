class FormContentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_context
  #before_filter :page_administrator!
  layout "admin"

  def edit
    return unless administrator!
    @form_builder_form = FormBuilderForm.new(form: @form)
    if @page
      @page_element = @page.page_elements.where('element_id = ?', @form.id).first
    end
    @edit_context_url = edit_form_path(@form, @context_params)
    @message = "Editing #{@page.name} Page" if @page

    respond_to do |format|
      format.html { render :action => "edit", :layout => 'admin' }
      format.json { render :partial => "edit" }
    end
  end

  def update
    return unless administrator!
    @form_builder_form = FormBuilderForm.new(form: @form)
    if @page
      page_element = @page.page_elements.build({
        page: @page,
        element: @form,
        index: @page.page_elements.length + 1
      })
    end

    respond_to do |format|
      if @form_builder_form.update_attributes(form_builder_params)
        format.html { redirect_to(@context_url,
          :notice => 'Form contents were successfully updated.') }
        format.json { render :json => {result: 'ok', redirect_to: @context_url} }
      else
        format.html {
          render :action => "edit", :layout => "admin"
        }
        format.json { render :json => 'error' }
      end
    end
  end

  private

  def get_context
    @form = Form.find(params[:id])
    @page = Page.find(params[:page_id]) if params[:page_id]
    if @page
      @context_url = edit_contents_page_url(@page)
      @context_params = { page_id: @page.id }
    else
      @context_url = form_fills_url(@form)
      @context_params = {}
    end
  end

  # def get_form
  #   @form = Form.find(params[:id])
  #   if params[:page_id]
  #     @page = Page.find(params[:page_id])
  #   end
  # end
  #
  # def context_url
  #   @page ? edit_contents_page_url(@page) : form_fills_url(@form)
  # end

  def form_builder_params
    params.require(:form).permit(:id, :name,
      {:form_sections => [:id, :name, :form_index, :depends_on_id,
        {:form_fields => [:id, :name, :form_index,
          :field_type, :help, :required, :monetary, :value, :limit,
          :depends_on_id, :unit_value,
          {:form_field_options => [:id, :name, :option_type,
            :help, :disabled, :value, :limit, :form_field_index]}
        ]}
      ]}
    )
  end

end
