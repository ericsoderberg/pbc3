class FormFieldsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!
  before_filter :get_form
  
  # GET /form_fields
  # GET /form_fields.xml
  def index
    @form_fields = @form.form_fields

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @form_fields }
    end
  end

  # GET /form_fields/1
  # GET /form_fields/1.xml
  def show
    @form_field = @form.form_fields.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @form_field }
      format.js
    end
  end

  # GET /form_fields/new
  # GET /form_fields/new.xml
  def new
    @form_field = @form.form_fields.build
    @form_field.field_type = FormField::FIELD
    @form_field.index = @form.form_fields.length + 1
    @form_field.name = "New Field #{@form_field.index}"
    @form_field.save

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @form_field }
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
    @form_field = @form.form_fields.new(params[:form_field])

    respond_to do |format|
      if @form_field.save
        format.html { redirect_to(form_field_url(@form, @form_field),
          :notice => 'Form field was successfully created.') }
        format.xml  { render :xml => @form_field, :status => :created, :location => @form_field }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @form_field.errors, :status => :unprocessable_entity }
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
        format.xml  { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @form_field.errors, :status => :unprocessable_entity }
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
      format.xml  { head :ok }
      format.js
    end
  end
  
  private
  
  def get_form
    @form = Form.find(params[:form_id])
  end
  
end
