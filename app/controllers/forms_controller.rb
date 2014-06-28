class FormsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /forms
  # GET /forms.xml
  def index
    @forms = if params[:page_id]
        @page = Page.find(params[:page_id])
        return unless page_administrator!
        session[:edit_form_cancel_path] = forms_path(:page_id => @page.id)
        @page.forms
      else
        return unless administrator!
        session[:edit_form_cancel_path] = forms_path()
        @forms = Form.order('name ASC')
      end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @forms }
    end
  end

  # GET /forms/1
  # GET /forms/1.xml
  def show
    @form = Form.find(params[:id])
    @page = @form.page
    return unless page_administrator!
    @filled_forms = @form.visible_filled_forms(current_user)
    @payments = @form.payments_for_user(current_user)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @form }
    end
  end

  # GET /forms/new
  # GET /forms/new.xml
  def new
    @form = Form.new
    @form.page = Page.find(params[:page_id]) if params[:page_id]
    @page = @form.page
    return unless page_administrator!
    @copy_form = nil
    @possible_parents = @form.page.forms if @form.page

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
    @page = @form.page
    return unless page_administrator!
    render :action => 'new'
  end

  # GET /forms/1/edit
  def edit
    @form = Form.find(params[:id])
    @page = @form.page
    return unless page_administrator!
    @events = @page.events.between(Date.today, Date.today + 3.months).
      where('events.master_id IS NULL')
    @pages = Page.editable(current_user)
    @cancel_path = session[:edit_form_cancel_path] || page_path(@page)
    @possible_parents = @form.page.forms.delete_if{|f| f.id == @form.id}
  end
  
  def edit_fields
    @form = Form.find(params[:id])
    @page = @form.page
    return unless page_administrator!
    if @form.form_sections.empty?
      @form.migrate
    end
    @cancel_path = session[:edit_form_cancel_path] || page_path(@page)
  end

  # POST /forms
  # POST /forms.xml
  def create
    @form = Form.new(form_params)
    if params.has_key?(:copy_form_id)
      @copy_form = Form.find(params[:copy_form_id])
      @form.copy(@copy_form)
    end
    @page = @form.page
    return unless page_administrator!

    respond_to do |format|
      if @form.save and (@copy_form or @form.create_default_fields)
        format.html { redirect_to(edit_fields_form_url(@form),
          :notice => 'Form was successfully created.') }
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
    @page = @form.page
    return unless page_administrator!
    if params[:field_order]
      ordered_field_ids = params[:field_order].split(',').map{|id| id.to_i}
    end
    if params[:section_order]
      ordered_section_ids = params[:section_order].split(',').map{|id| id.to_i}
    end
    if params[:advance_version]
      params[:form][:version] = @form.version + 1
    end

    respond_to do |format|
      if (not params[:form] or @form.update_attributes(form_params)) and
        (not ordered_field_ids or @form.order_fields(ordered_field_ids) and
        (not ordered_section_ids or @form.order_sections(ordered_section_ids)))
        format.html { redirect_to(new_form_fill_path(@form),
          :notice => 'Form was successfully updated.') }
        format.js { head :ok }
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
    @page = @form.page
    return unless page_administrator!
    @form.destroy

    respond_to do |format|
      format.html { redirect_to(forms_url(:page_id => @page.id)) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def form_params
    params.require(:form).permit(:name, :page_id, :event_id,
      :payable, :published, :pay_by_check, :pay_by_paypal,
      :updated_by, :version, :parent_id, :authenticated,
      :many_per_user, :authentication_text).merge(:updated_by => current_user)
  end
  
end
