class FormFieldsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!
  before_filter :get_form

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
    @form_field = @form.form_fields.new
    @form_field.field_type = FormField::FIELD
    @form_field.form_index = @form.form_fields.length + 1
    @form_field.name = "New Field #{@form_field.form_index}"

    respond_to do |format|
      if @form_field.save
        format.html { redirect_to(form_field_url(@form, @form_field),
          :notice => 'Form field was successfully created.') }
        format.js
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /form_fields/1
  # PUT /form_fields/1.xml
  def update
    @form_field = @form.form_fields.find(params[:id])

    respond_to do |format|
      if @form_field.update_attributes(params[:form_field])
        format.html { redirect_to(@form_field, :notice => 'Form field was successfully updated.') }
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
  end
  
end
