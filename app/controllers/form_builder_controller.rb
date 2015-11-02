class FormBuilderController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_form
  #before_filter :page_administrator!
  layout "administration", only: [:edit, :update]

  def edit
    return unless administrator!
    @form_builder_form = FormBuilderForm.new(form: @form)
    @page = @form.page
    @cancel_url = context_url(@page)
  end

  def update
    return unless administrator!
    @form_builder_form = FormBuilderForm.new(form: @form)
    @page = Page.where(id: params[:page_id]).first
    if @page
      page_element = @page.page_elements.build({
        page: @page,
        element: @form,
        index: @page.page_elements.length + 1
      })
    end
    target_url = context_url(@page)

    respond_to do |format|
      if @form_builder_form.update_attributes(form_builder_params)
        format.html { redirect_to(target_url,
          :notice => 'Form contents were successfully updated.') }
        format.json { render :json => {result: 'ok', redirect_to: target_url} }
      else
        format.html {
          render :action => "edit", :layout => "administration"
        }
        format.json { render :json => 'error' }
      end
    end
  end

  private

  def get_form
    @form = Form.find(params[:id])
    #@page = @form.page
  end

  def context_url(page)
    page ? edit_contents_page_url(page) : forms_url()
  end

  def form_builder_params
    params.require(:form).permit(:id, :name,
      {:form_sections => [:id, :name, :form_index,
        {:form_fields => [:id, :name, :form_index,
          :field_type, :help, :required, :monetary, :value, :limit,
          {:form_field_options => [:id, :name, :option_type,
            :help, :disabled, :value, :form_field_index]}
        ]}
      ]}
    )
  end

end
