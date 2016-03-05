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

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :partial => "index" }
    end
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
    @message = "Editing #{@page.name} Page" if @page

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
    @message = "Editing #{@page.name} Page" if @page
  end

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

    respond_to do |format|
      if @form.save
        format.html {
          target_url = @page ? edit_contents_form_url(@form, {:page_id => @page.id}) :
            edit_contents_form_url(@form)
          redirect_to(target_url,
            :notice => 'Form was successfully created.')
        }
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

  def destroy
    return unless administrator!
    @form = Form.find(params[:id])
    @page = @form.page
    #return unless page_administrator!
    @form.destroy
    @form = nil
    target_url = context_url

    respond_to do |format|
      format.html { redirect_to(target_url) }
      format.xml  { head :ok }
    end
  end

  private

  def context_url
    (@page ? edit_contents_page_url(@page) :
      ((@form and @form.id) ? form_fills_url(@form) : forms_url))
  end

  def form_params
    params.require(:form).permit(:name, #:page_id, :event_id,
      :payable, :published, :pay_by_check, :pay_by_paypal,
      :updated_by, :version, :parent_id, :authenticated,
      :many_per_user, :authentication_text, :submit_label
      #:call_to_action
      ).merge(:updated_by => current_user)
  end

end
