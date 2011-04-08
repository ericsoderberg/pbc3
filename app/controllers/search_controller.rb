class SearchController < ApplicationController
  
  def search
    @search = Page.search{ keywords(params[:q]) }
  end

end
