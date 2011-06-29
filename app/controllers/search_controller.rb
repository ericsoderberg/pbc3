class SearchController < ApplicationController
  
  def search
    @search_text = params[:q]
    classes = [Page, Message, Event]
    classes << User if user_signed_in? and current_user.administrator?
    @search = Sunspot.search(*classes) do
      keywords params[:q]
      paginate(:page => (params[:page] || 1))
      without(:best, false)
    end
  end

end
