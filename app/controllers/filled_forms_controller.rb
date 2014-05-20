class FilledFormsController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :create, :edit, :update, :destroy]
  before_filter :get_form, :except => [:user_index]
  
  # GET /filled_forms
  # GET /filled_forms.xml
  def index
    @sort = params[:sort] || 'name'
    @sort_id = @sort.to_i
    @filled_forms = @form.visible_filled_forms(current_user)
    if @sort
      if @sort_id <= 0
        @filled_forms = @filled_forms.reorder(@sort + ' ASC')
      else
        @filled_forms = @filled_forms.includes(:filled_fields).
          where('filled_fields.form_field_id = ?', @sort_id).
          reorder('filled_fields.value').references(:filled_fields)
      end
    end
    
    @payable_forms = @filled_forms.for_user(current_user).
      where(:payment_id => nil)
      
    if @form.parent
      @parent_value_form_fields = @form.parent.form_fields.valued
      @parent_columns = @form.parent.columns
    end
    
    @value_form_fields = @form.form_fields.valued
    @columns = @form.columns
      
    @sort_options = @value_form_fields.map{|ff| [ff.name, ff.id]}
    @sort_options << ['date', 'updated_at']
    @sort_options << ['version']
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @filled_forms }
      format.csv # index.csv.erb
      format.xls # index.xls.erb
    end
  end
  
  def user_index
    @user = User.find(params[:id])
    @user = current_user unless current_user.administrator?
    @filled_forms = @user.filled_forms.to_a

    respond_to do |format|
      format.html # user_index.html.erb
      format.xml  { render :xml => @filled_forms }
    end
  end

  # GET /filled_forms/1
  # GET /filled_forms/1.xml
  def show
    @filled_form = @form.filled_forms.find(params[:id])
    return unless filled_form_authorized!

    respond_to do |format|
      format.html # show.html.erb
      format.text
    end
  end

  # GET /filled_forms/new
  # GET /filled_forms/new.xml
  def new
    @filled_form = @form.build_fill
    if current_user
      @filled_form.user = current_user
      @filled_forms = @form.visible_filled_forms(current_user)
    elsif @form.authenticated?
      session[:post_login_path_override] = request.original_url
      #redirect_to new_user_session_url(:protocol => 'https')
      @new_user = User.new
      @devise_mapping ||= Devise.mappings[:user]
      render 'authenticate'
      return
    end
    session[:edit_form_cancel_path] = new_form_fill_path(@form)
    if @form.parent
      @parent_filled_forms = @form.parent.visible_filled_forms(current_user)
      @filled_form.parent = @parent_filled_forms.first
    end
    @payments = @form.payments_for_user(current_user)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @filled_form }
    end
  end

  # GET /filled_forms/1/edit
  def edit
    @filled_form = @form.filled_forms.find(params[:id])
    @filled_forms = @form.visible_filled_forms(current_user)
    return unless filled_form_authorized!
    session[:edit_form_cancel_path] = edit_form_fill_path(@form, @filled_form)
    if @form.parent
      @parent_filled_forms = @form.parent.visible_filled_forms(current_user)
    end
    @payments = @form.payments_for_user(current_user)
  end

  # POST /filled_forms
  # POST /filled_forms.xml
  def create
    if not params[:email_address_confirmation].empty?
      redirect_to root_path
      return
    end
    @filled_form = @form.filled_forms.new
    if current_user and current_user.administrator? and params[:filled_form] and
      params[:filled_form][:user_id]
      @filled_form.user = User.find(params[:filled_form][:user_id])
    else
      @filled_form.user = current_user
    end
    if params[:filled_form] and params[:filled_form][:parent_id]
      @filled_form.parent = FilledForm.find(params[:filled_form][:parent_id])
    end
    @filled_form.version = @form.version
    populate_filled_fields
    
    if @form.payable?
      # re-use payment from sibling filled forms that haven't been paid
      siblings = @form.filled_forms_for_user(current_user)
      siblings.each do |sibling_filled_form|
        if sibling_filled_form.payment and sibling_filled_form.payment.cancellable?
          @payment = sibling_filled_form.payment
          break
        end
      end
      unless @payment
        @payment = Payment.new(:amount => @filled_form.payable_amount,
          :method => Payment::METHODS.first, :user => @filled_form.user)
        end
      @payment.filled_forms << @filled_form
    end

    respond_to do |format|
      if @filled_form.save and (! @payment or
        (@payment.amount += @filled_form.payable_amount; @payment.save))
        FormMailer.form_email(@filled_form).deliver
        format.html { redirect_to(next_url,
            :notice => "#{@form.name} was successfully submitted.") }
        format.xml  { render :xml => @filled_form, :status => :created, :location => @filled_form }
      else
        @filled_forms = @form.visible_filled_forms(current_user)
        @payments = @form.payments_for_user(current_user)
        format.html { render :action => "new" }
        format.xml  { render :xml => @filled_form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /filled_forms/1
  # PUT /filled_forms/1.xml
  def update
    @filled_form = @form.filled_forms.find(params[:id])
    return unless filled_form_authorized!
    if current_user.administrator? and params[:filled_form] and
      params[:filled_form][:user_id]
      if not params[:filled_form][:user_id].empty?
        @filled_form.user = User.find(params[:filled_form][:user_id])
      else
        @filled_form.user = nil
      end
    else
      @filled_form.user = current_user
    end
    if params[:filled_form] and params[:filled_form][:parent_id]
      @filled_form.parent = FilledForm.find(params[:filled_form][:parent_id])
    end
    @filled_form.version = @form.version
    populate_filled_fields
    @payment = @filled_form.payment

    respond_to do |format|
      if @filled_form.save
        FormMailer.form_email(@filled_form).deliver
        format.html { redirect_to(next_url,
          :notice => "#{@form.name} was successfully updated.") }
        format.xml  { head :ok }
      else
        @filled_forms = @form.visible_filled_forms(current_user)
        @payments = @form.payments_for_user(current_user)
        format.html { render :action => "edit" }
        format.xml  { render :xml => @filled_form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /filled_forms/1
  # DELETE /filled_forms/1.xml
  def destroy
    if params[:filled_form_key]
      @filled_form = FilledForm.where(:verification_key =>
        params[:filled_form_key]).first
    else
      @filled_form = @form.filled_forms.find(params[:id])
    end
    return unless filled_form_authorized!
    if (@filled_form.payment and
      @filled_form.payment.filled_forms.length == 1 and
      @filled_form.payment.cancellable?)
      @filled_form.payment.destroy
    end
    @filled_form.destroy

    respond_to do |format|
      format.html do
        if params[:filled_form_key]
          redirect_to friendly_page_url(@page)
        else
          @next_filled_form = @form.visible_filled_forms(current_user).first()
          if @next_filled_form
            redirect_to edit_form_fill_url(@form, @next_filled_form)
          else
            redirect_to new_form_fill_url(@form)
          end
        end
      end
      format.xml  { head :ok }
    end
  end
  
  private
  
  def filled_form_authorized!
    filled_form_key = params[:filled_form_key]
    if (current_user and
        (current_user.administrator? or @page.administrator?(current_user))) or
      (current_user and @filled_form.user == current_user) or
      (filled_form_key and @filled_form.verification_key == filled_form_key)
      return true
    end
    if not current_user
      session[:post_login_path] = request.original_url
      redirect_to new_user_session_path
    else
      redirect_to friendly_page_url(@page)
    end
    return false
  end
  
  def get_form
    @form = Form.find(params[:form_id])
    @page = @form.page
    if not @form.visible?(current_user)
      redirect_to friendly_page_url(@page)
      return false
    end
    session[:edit_form_cancel_path] = form_fills_path(@form)
    return true
  end
  
  def populate_option(form_field, filled_field, filled_option, value)
    filled_option = filled_field.filled_field_options.build unless filled_option
    option = form_field.form_field_options.find(value)
    if filled_option.form_field_option != option
      filled_option.form_field_option = option
      filled_option.updated_at = Time.now
    end
    filled_option.value = (option.value ? option.value : option.name)
  end
  
  def populate_options(form_field, filled_field, value)
    prior_options = filled_field.filled_field_options.to_a
    index = 0
    value.each do |one_value|
      populate_option(form_field, filled_field, prior_options[index], one_value)
      index += 1
    end
    while index < filled_field.filled_field_options.size
      filled_field.filled_field_options.delete(prior_options[index])
    end
  end
  
  def populate_value(form_field, filled_field, value)
    # create a new one if needed
    unless filled_field
      filled_field = @filled_form.filled_fields.build
      filled_field.filled_form = @filled_form
      filled_field.form_field = form_field
    end
    # populate value
    case form_field.field_type
    when FormField::FIELD, FormField::SINGLE_LINE
      filled_field.value = value
    when FormField::AREA, FormField::MULTIPLE_LINES
      filled_field.value = value
    when FormField::SINGLE_CHOICE
      populate_options(form_field, filled_field, [value])
    when FormField::MULTIPLE_CHOICE
      populate_options(form_field, filled_field, value)
    when FormField::COUNT
      filled_field.value = value
    end
  end
  
  def populate_filled_fields
    @filled_form.name = nil
    @form.form_fields.each do |form_field|
      field_id = form_field.id
      # see if we already have a prior value
      filled_field = @filled_form.filled_fields.detect{|f|
        f.form_field_id == field_id}
      # see if the user provided a new value
      if params[:filled_fields].has_key?(field_id.to_s)
        # field was filled out
        # get submitted value
        value = params[:filled_fields][field_id.to_s][:value]
        populate_value(form_field, filled_field, value)
        # guess at name
        if not @filled_form.name and form_field.name =~ /name/i
          @filled_form.name = value
        end
      else
        # field was not filled out
        @filled_form.filled_fields.delete(filled_field) if filled_field
      end
    end

    # use user name or email if we don't have a name yet
    unless @filled_form.name
      if current_user and current_user == @filled_form.user
        @filled_form.name = current_user.name || current_user.email
      else
        @filled_form.name = 'anonymous'
      end
    end
    @filled_form.updated_at = Time.now
  end
  
  def next_url
    if current_user and @form.many_per_user?
      new_form_fill_url(@form)
    elsif @form.payable?
      if @payment.cancellable?
        edit_payment_url(@payment,
          {:filled_form_key => @filled_form.verification_key,
           :verification_key => @payment.verification_key})
      else
        payment_url(@payment,
          {:verification_key => @payment.verification_key})
      end
    elsif not @form.children.empty?
      child_form = @form.children.first
      filled_form = child_form.filled_forms_for_user(current_user).first
      if filled_form
        edit_form_fill_url(child_form, filled_form)
      else
        new_form_fill_url(child_form)
      end
    else
      friendly_page_url(@page)
    end
  end
  
end
