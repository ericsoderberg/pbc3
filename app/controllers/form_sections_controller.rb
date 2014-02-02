class FormSectionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_form
  before_filter :page_administrator!
  
  def show
    @form_section = @form.form_sections.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.js
    end
  end
  
  def edit
    @form_section = @form.form_sections.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
    @form_section = @form.form_sections.new
    @form_section.form_index = @form.next_index
    @form_section.name = "New Section #{@form_section.form_index}"

    respond_to do |format|
      if @form_section.save
        format.html { redirect_to(form_section_url(@form, @form_section),
          :notice => 'Form section was successfully created.') }
        format.js
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def update
    @form_section = @form.form_sections.find(params[:id])

    respond_to do |format|
      if @form_section.update_attributes(form_section_params)
        format.html { redirect_to(@form_section, :notice => 'Form section was successfully updated.') }
        format.js
      else
        format.html { render :action => "edit" }
        format.js  { render :action => "edit" }
      end
    end
  end
  
  def copy
    source_form_section = @form.form_sections.find(params[:id])
    @source_id = source_form_section.id
    @form_section = @form.form_sections.new
    @form_section.form = @form
    @form_section.copy(source_form_section)

    respond_to do |format|
      if @form_section.save
        format.html { redirect_to(@form_section, :notice => 'Form section was successfully copied.') }
        format.js
      else
        format.html { render :action => "edit" }
        format.js  { render :action => "edit" }
      end
    end
  end
  
  def destroy
    @form_section = @form.form_sections.find(params[:id])
    @id = @form_section.id
    @form_section.destroy

    respond_to do |format|
      format.html { redirect_to(form_fields_url) }
      format.js
    end
  end
  
  private
  
  def get_form
    @form = Form.find(params[:form_id])
    @page = @form.page
  end
  
  def form_section_params
    params.require(:form_section).permit(:form_id, :form_index, :name)
  end
end
