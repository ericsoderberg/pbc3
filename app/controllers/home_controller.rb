class HomeController < ApplicationController
  
  def index
    @pages = Page.find(:all)
  end

end
