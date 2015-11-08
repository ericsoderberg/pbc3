class FormsController < ApplicationController
  before_filter :authenticate_user!
  layout "administration", only: [:new, :create, :edit, :edit_contents, :update, :delete]

  def index
    return unless administrator!
    @filter = {}
    @filter[:search] = params[:search]

    @forms = Form
    if @filter[:search]
      @forms = Form.search(@filter[:search])
    end
    @forms = @forms.order('LOWER(name) ASC')

    # get total count before we limit
    @count = @forms.count

    if params[:offset]
      @forms = @forms.offset(params[:offset])
    end
    @forms = @forms.limit(20)

    @content_partial = 'forms/index'

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :partial => "index" }
    end
=begin
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
=end
  end

  def show
    @form = Form.find(params[:id])
    return unless administrator!
    @filled_forms = @form.visible_filled_forms(current_user)
    @payments = @form.payments_for_user(current_user)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @form }
    end
  end

  def new
    return unless administrator!
    @form = Form.new
    if params[:page_id]
      @page = Page.find(params[:page_id])
      @page_element = @form.page_elements.build({
        page: @page,
        element: @form,
        element_type: 'Form'
      })
      @form.name = @page.name
      @forms = Form.order('name ASC')
    end
    @cancel_url = context_url
    #@form.page = Page.find(params[:page_id]) if params[:page_id]
    #@page = @form.page
    #return unless page_administrator!
    @copy_form = nil
    #@possible_parents = @form.page.forms if @form.page

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @form }
    end
  end

  def copy
    return unless administrator!
    @copy_form = Form.find(params[:id])
    @form = Form.new
    @form.name = @copy_form.name + ' Copy'
    #@form.page = @copy_form.page
    #@page = @form.page
    #return unless page_administrator!
    render :action => 'new'
  end

  def edit
    return unless administrator!
    @form = Form.find(params[:id])
    if params[:page_id]
      @page = Page.find(params[:page_id])
      @page_element = @page.page_elements.where('element_id = ?', @form.id).first
    end
    @cancel_url = context_url
    @edit_contents_url = @page ?
      edit_contents_form_path(@form, {:page_id => @page.id}) :
      edit_contents_form_path(@form)
    #@page = @form.page
    #return unless page_administrator!
    #@events = @page.events.between(Date.today, Date.today + 3.months).
    #  where('events.master_id IS NULL')
    #@pages = Page.editable(current_user)
    #@cancel_path = session[:edit_form_cancel_path] || page_path(@page)
    #@possible_parents = @form.page.forms.to_a.delete_if{|f| f.id == @form.id}
  end

=begin
  def edit_contents
    return unless administrator!
    @form = Form.find(params[:id])
    #@page = @form.page
    #return unless page_administrator!
    if @form.form_sections.empty?
      @form.migrate
    end
    #@cancel_path = session[:edit_form_cancel_path] || page_path(@page)
  end
=end

  def create
    return unless administrator!
    @form = Form.new(form_params)
    if params.has_key?(:copy_form_id)
      @copy_form = Form.find(params[:copy_form_id])
      @form.copy(@copy_form)
    end
    if params[:page_id]
      @page = Page.find(params[:page_id])
      @page_element = @page.page_elements.where('element_id = ?', @form.id).first
    end
    target_url = context_url
    #@page = @form.page
    #return unless page_administrator!

    respond_to do |format|
      if @form.save
        format.html { redirect_to(target_url,
          :notice => 'Form was successfully created.') }
        format.xml  { render :xml => @form, :status => :created, :location => @form }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @form.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    return unless administrator!
    @form = Form.find(params[:id])
    if params[:page_id]
      @page = Page.find(params[:page_id])
      @page_element = @page.page_elements.where('element_id = ?', @form.id).first
    end
    #@page = @form.page
    #return unless page_administrator!
    if params[:advance_version]
      params[:form][:version] = @form.version + 1
    end
    target_url = context_url

    respond_to do |format|
      if (@form.update_attributes(form_params))
        format.html { redirect_to(target_url,
          :notice => 'Form was successfully updated.') }
        format.js { head :ok }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @form.errors, :status => :unprocessable_entity }
      end
    end
  end

=begin
  def update_contents
    return unless administrator!
    @form = Form.find(params[:id])
    respond_to do |format|
      if @form.update_contents(form_contents_params)
        format.html { redirect_to(forms_path,
          :notice => 'Form contents were successfully updated.') }
        format.json { render :json => 'ok' }
      else
        format.html {
          render :action => "edit_contents", :layout => "administration"
        }
        format.json { render :json => 'error' }
      end
    end
  end
=end

  def destroy
    return unless administrator!
    @form = Form.find(params[:id])
    @page = @form.page
    #return unless page_administrator!
    @form.destroy
    target_url = context_url

    respond_to do |format|
      format.html { redirect_to(target_url) }
      format.xml  { head :ok }
    end
  end

  private

  def context_url
    @page ? edit_contents_page_url(@page) : form_fills_url(@form)
  end

  def form_params
    params.require(:form).permit(:name, #:page_id, :event_id,
      :payable, :published, :pay_by_check, :pay_by_paypal,
      :updated_by, :version, :parent_id, :authenticated,
      :many_per_user, :authentication_text, :submit_label
      #:call_to_action
      ).merge(:updated_by => current_user)
  end

=begin
  def form_contents_params
    params.permit(:name,
      {:formSections => [:id, :name, :formIndex,
        {:formFields => [:id, :name, :formIndex,
          :fieldType, :help, :required, :monetary, :value, :limit,
          {:formFieldOptions => [:id, :name, :optionType, :help, :disabled, :value]}
        ]}
      ]}
    )
  end

  def form_contents_params2
    # convert to a hash since couldn't get permit to work
    form = {}
    form[:form_sections] = params[:formSections].map do |fs|
      form_section = {id: fs[:id], name: fs[:name], form_index: fs[:formIndex]}
      form_section[:form_fields] = fs[:formFields].map do |f|
        form_field = {id: f[:id], name: f[:name], form_index: f[:formIndex],
          field_type: f[:fieldType], help: f[:help], required: f[:required], monetary: f[:monetary],
          limit: f[:limit]}
        if f[:formFieldOptions]
          form_field[:form_field_options] = f[:formFieldOptions].map do |o|
            {id: o[:id], name: o[:name], form_field_index: o[:formFieldIndex],
              help: o[:help], value: o[:value]}
          end
        end
        form_field
      end
      form_section
    end
    form
  end
=end

end
