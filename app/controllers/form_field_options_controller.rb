class FormFieldOptionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!
  before_filter :get_form_and_field
  
  # GET /form_field_options
  # GET /form_field_options.xml
  def index
    @form_field_options = @field.form_field_options.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @form_field_options }
    end
  end

  # GET /form_field_options/1
  # GET /form_field_options/1.xml
  def show
    @form_field_option = @field.form_field_options.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @form_field_option }
    end
  end

  # GET /form_field_options/new
  # GET /form_field_options/new.xml
  def new
    @form_field_option = @field.form_field_options.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @form_field_option }
    end
  end

  # GET /form_field_options/1/edit
  def edit
    @form_field_option = @field.form_field_options.find(params[:id])
  end

  # POST /form_field_options
  # POST /form_field_options.xml
  def create
    @form_field_option = @field.form_field_options.new(params[:form_field_option])

    respond_to do |format|
      if @form_field_option.save
        format.html { redirect_to(@form_field_option, :notice => 'Form field option was successfully created.') }
        format.xml  { render :xml => @form_field_option, :status => :created, :location => @form_field_option }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @form_field_option.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /form_field_options/1
  # PUT /form_field_options/1.xml
  def update
    @form_field_option = FormFieldOption.find(params[:id])

    respond_to do |format|
      if @form_field_option.update_attributes(params[:form_field_option])
        format.html { redirect_to(@form_field_option, :notice => 'Form field option was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @form_field_option.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /form_field_options/1
  # DELETE /form_field_options/1.xml
  def destroy
    @form_field_option = FormFieldOption.find(params[:id])
    @form_field_option.destroy

    respond_to do |format|
      format.html { redirect_to(form_field_options_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def get_form_and_field
    @form = Form.find(params[:form_id])
    @field = @form.fields.find(params[:field_id])
  end
  
end
