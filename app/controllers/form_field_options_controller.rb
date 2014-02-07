class FormFieldOptionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_form_and_field
  before_filter :page_administrator!

  # GET /form_field_options/1
  # GET /form_field_options/1.xml
  def show
    @form_field_option = @form_field.form_field_options.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  # GET /form_field_options/1/edit
  def edit
    @form_field_option = @form_field.form_field_options.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  # POST /form_field_options
  # POST /form_field_options.xml
  def create
    @form_field_option = @form_field.form_field_options.new(
      :name => "Option-#{@form_field.form_field_options.length + 1}",
      :option_type => FormFieldOption::FIXED,
      :form_field_index => (@form_field.form_field_options.length + 1))

    respond_to do |format|
      if @form_field_option.save
        format.js
      end
    end
  end

  # PUT /form_field_options/1
  # PUT /form_field_options/1.xml
  def update
    @form_field_option = @form_field.form_field_options.find(params[:id])

    respond_to do |format|
      if @form_field_option.update_attributes(form_field_option_params)
        format.js
      end
    end
  end

  # DELETE /form_field_options/1
  # DELETE /form_field_options/1.xml
  def destroy
    @form_field_option_id = params[:id]
    @form_field_option = @form_field.form_field_options.find(params[:id])
    @form_field_option.destroy

    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def get_form_and_field
    @form = Form.find(params[:form_id])
    @form_field = @form.form_fields.find(params[:field_id])
    @page = @form.page
  end
  
  def form_field_option_params
    params.require(:form_field_option).permit(:form_field_id, :form_field_index, :name,
      :option_type, :help, :size, :disabled, :value)
  end
  
end
