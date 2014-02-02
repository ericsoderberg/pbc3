class FormFieldsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_form
  before_filter :page_administrator!

  # GET /form_fields/1
  # GET /form_fields/1.xml
  def show
    @form_field = @form.form_fields.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.js
    end
  end

  # GET /form_fields/1/edit
  def edit
    @form_field = @form.form_fields.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /form_fields
  # POST /form_fields.xml
  def create
    @form_field = @form_section.form_fields.new
    @form_field.form = @form
    @form_field.field_type = FormField::SINGLE_LINE
    @form_field.form_index = @form.next_index
    @form_field.name = "New Field #{@form_field.form_index}"

    respond_to do |format|
      if @form_field.save
        format.html { redirect_to(form_field_url(@form, @form_field),
          :notice => 'Form field was successfully created.') }
        format.js
      else
        format.html { render :action => "new" }
        format.js
      end
    end
  end

  # PUT /form_fields/1
  # PUT /form_fields/1.xml
  def update
    @form_field = @form.form_fields.find(params[:id])

    respond_to do |format|
      if @form_field.update_attributes(form_field_params)
        format.html { redirect_to(@form_field, :notice => 'Form field was successfully updated.') }
        format.js
      else
        format.html { render :action => "edit" }
        format.js  { render :action => "edit" }
      end
    end
  end
  
  def copy
    source_form_field = @form.form_fields.find(params[:id])
    @source_id = source_form_field.id
    @form_field = @form.form_fields.new
    @form_field.form = @form
    @form_field.form_section = source_form_field.form_section
    @form_field.copy(source_form_field)

    respond_to do |format|
      if @form_field.save
        format.html { redirect_to(@form_field, :notice => 'Form field was successfully copied.') }
        format.js
      else
        format.html { render :action => "edit" }
        format.js  { render :action => "edit" }
      end
    end
  end

  # DELETE /form_fields/1
  # DELETE /form_fields/1.xml
  def destroy
    @form_field = @form.form_fields.find(params[:id])
    @id = @form_field.id
    @form_field.destroy

    respond_to do |format|
      format.html { redirect_to(form_fields_url) }
      format.js
    end
  end
  
  private
  
  def get_form
    @form = Form.find(params[:form_id])
    @page = @form.page
    if params[:form_section_id]
      @form_section = @form.form_sections.find(params[:form_section_id])
    end
  end
  
  def form_field_params
    params.require(:form_field).permit(:form_id, :form_index, :name,
      :field_type, :help, :size, :required, :monetary, :dense, :value, :prompt, :limit)
  end
  
end
