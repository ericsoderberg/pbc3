class SocialController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_page
  before_filter :page_administrator!
  
  def edit
  end
  
  def update
    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to(edit_page_path(@page),
          :notice => 'Page was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

end
