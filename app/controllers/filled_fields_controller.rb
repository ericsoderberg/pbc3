# class FilledFieldsController < ApplicationController
#   # GET /filled_fields
#   # GET /filled_fields.xml
#   def index
#     @filled_fields = FilledField.to_a
#
#     respond_to do |format|
#       format.html # index.html.erb
#       format.xml  { render :xml => @filled_fields }
#     end
#   end
#
#   # GET /filled_fields/1
#   # GET /filled_fields/1.xml
#   def show
#     @filled_field = FilledField.find(params[:id])
#
#     respond_to do |format|
#       format.html # show.html.erb
#       format.xml  { render :xml => @filled_field }
#     end
#   end
#
#   # GET /filled_fields/new
#   # GET /filled_fields/new.xml
#   def new
#     @filled_field = FilledField.new
#
#     respond_to do |format|
#       format.html # new.html.erb
#       format.xml  { render :xml => @filled_field }
#     end
#   end
#
#   # GET /filled_fields/1/edit
#   def edit
#     @filled_field = FilledField.find(params[:id])
#   end
#
#   # POST /filled_fields
#   # POST /filled_fields.xml
#   def create
#     @filled_field = FilledField.new(params[:filled_field])
#
#     respond_to do |format|
#       if @filled_field.save
#         format.html { redirect_to(@filled_field, :notice => 'Filled field was successfully created.') }
#         format.xml  { render :xml => @filled_field, :status => :created, :location => @filled_field }
#       else
#         format.html { render :action => "new" }
#         format.xml  { render :xml => @filled_field.errors, :status => :unprocessable_entity }
#       end
#     end
#   end
#
#   # PUT /filled_fields/1
#   # PUT /filled_fields/1.xml
#   def update
#     @filled_field = FilledField.find(params[:id])
#
#     respond_to do |format|
#       if @filled_field.update_attributes(params[:filled_field])
#         format.html { redirect_to(@filled_field, :notice => 'Filled field was successfully updated.') }
#         format.xml  { head :ok }
#       else
#         format.html { render :action => "edit" }
#         format.xml  { render :xml => @filled_field.errors, :status => :unprocessable_entity }
#       end
#     end
#   end
#
#   # DELETE /filled_fields/1
#   # DELETE /filled_fields/1.xml
#   def destroy
#     @filled_field = FilledField.find(params[:id])
#     @filled_field.destroy
#
#     respond_to do |format|
#       format.html { redirect_to(filled_fields_url) }
#       format.xml  { head :ok }
#     end
#   end
# end
