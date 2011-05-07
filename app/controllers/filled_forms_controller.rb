class FilledFormsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_form, :except => ['user_index']
  
  # GET /filled_forms
  # GET /filled_forms.xml
  def index
    @filled_forms = @form.filled_forms.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @filled_forms }
    end
  end
  
  def user_index
    @user = User.find(params[:id])
    @filled_forms = @user.filled_forms.all

    respond_to do |format|
      format.html # user_index.html.erb
      format.xml  { render :xml => @filled_forms }
    end
  end

  # GET /filled_forms/1
  # GET /filled_forms/1.xml
  def show
    @filled_form = @form.filled_forms.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.text
    end
  end

  # GET /filled_forms/new
  # GET /filled_forms/new.xml
  def new
    @filled_form = @form.build_fill
    @filled_form.user = current_user

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @filled_form }
    end
  end

  # GET /filled_forms/1/edit
  def edit
    @filled_form = @form.filled_forms.find(params[:id])
  end

  # POST /filled_forms
  # POST /filled_forms.xml
  def create
    @filled_form = @form.filled_forms.new
    @filled_form.user = current_user
    populate_filled_fields

    respond_to do |format|
      if @filled_form.save
        format.html { redirect_to(edit_form_fill_path(@form, @filled_form),
          :notice => 'Filled form was successfully created.') }
        format.xml  { render :xml => @filled_form, :status => :created, :location => @filled_form }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @filled_form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /filled_forms/1
  # PUT /filled_forms/1.xml
  def update
    @filled_form = @form.filled_forms.find(params[:id])
    populate_filled_fields

    respond_to do |format|
      if @filled_form.save
        format.html { redirect_to(edit_form_fill_path(@form, @filled_form),
          :notice => 'Filled form was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @filled_form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /filled_forms/1
  # DELETE /filled_forms/1.xml
  def destroy
    @filled_form = @form.filled_forms.find(params[:id])
    @filled_form.destroy

    respond_to do |format|
      format.html { redirect_to(new_form_fill_url(@form)) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def get_form
    @form = Form.find(params[:form_id])
  end
  
  def populate_filled_fields
    @filled_form.name = nil
    params[:filled_fields].each_key do |field_id|
      # get form field
      form_field = @form.form_fields.find(field_id)
      # get submitted value
      value = params[:filled_fields][field_id][:value]
      # see if we already have a prior value
      filled_field = @filled_form.filled_fields.detect{|f|
        f.form_field_id == form_field.id}
      # create a new one if needed
      unless filled_field
        filled_field = @filled_form.filled_fields.build
        filled_field.filled_form = @filled_form
        filled_field.form_field = form_field
      end
      # join check box responses
      filled_field.value = (value.is_a?(Array) ? value.join(',') : value)
      # guess at name
      if not @filled_form.name and form_field.name =~ /name/i
        @filled_form.name = value
      end
    end
    # use user name or email if we don't have a name yet
    if current_user == @filled_form.user and not @filled_form.name
      @filled_form.name = current_user.name || current_user.email
    end
    @filled_form.updated_at = Time.now
  end
  
end
