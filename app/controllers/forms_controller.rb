class FormsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :administrator!
  
  # GET /forms
  # GET /forms.xml
  def index
    @forms = Form.order('name ASC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @forms }
    end
  end

  # GET /forms/1
  # GET /forms/1.xml
  def show
    @form = Form.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @form }
    end
  end

  # GET /forms/new
  # GET /forms/new.xml
  def new
    @form = Form.new
    @copy_form = nil

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @form }
    end
  end
  
  def copy
    @copy_form = Form.find(params[:id])
    @form = Form.new
    @form.name = @copy_form.name + ' Copy'
    @form.page = @copy_form.page
    render :action => 'new'
  end

  # GET /forms/1/edit
  def edit
    @form = Form.find(params[:id])
  end

  # POST /forms
  # POST /forms.xml
  def create
    @form = Form.new(params[:form])
    if params.has_key?(:copy_form_id)
      @copy_form = Form.find(params[:copy_form_id])
      @form.copy(@copy_form)
    end

    respond_to do |format|
      if @form.save
        format.html { redirect_to(edit_form_url(@form), :notice => 'Form was successfully created.') }
        format.xml  { render :xml => @form, :status => :created, :location => @form }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /forms/1
  # PUT /forms/1.xml
  def update
    @form = Form.find(params[:id])
    ordered_field_ids = params[:field_order].split(',').map{|id| id.to_i}

    respond_to do |format|
      if @form.update_attributes(params[:form]) and
        @form.order_fields(ordered_field_ids)
        format.html { redirect_to(@form, :notice => 'Form was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /forms/1
  # DELETE /forms/1.xml
  def destroy
    @form = Form.find(params[:id])
    @form.destroy

    respond_to do |format|
      format.html { redirect_to(forms_url) }
      format.xml  { head :ok }
    end
  end
end
