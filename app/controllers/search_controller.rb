class SearchController < ApplicationController
  
  def search
    @search_text = params[:q]
    @search = Page.search{ keywords(params[:q]) }
  end

end
