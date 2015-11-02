class FormBuilderController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_form
  #before_filter :page_administrator!
  layout "administration", only: [:edit, :update]

  def edit
    return unless administrator!
    @form_builder_form = FormBuilderForm.new(form: @form)
  end

  def update
    return unless administrator!
    @form_builder_form = FormBuilderForm.new(form: @form)
    respond_to do |format|
      if @form_builder_form.update_attributes(form_builder_params)
        format.html { redirect_to(forms_path,
          :notice => 'Form contents were successfully updated.') }
        format.json { render :json => {result: 'ok', redirect_to: forms_path} }
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
