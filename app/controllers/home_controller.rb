class HomeController < ApplicationController
  
  def index
    @pages = Page.visible(current_user).where(['featured = ?', true]).order('feature_index ASC')
    @hero_page = Page.find_by_id(params[:page]) || @pages.first
    if @hero_page
      @hero_photo1 = @hero_page.photos.first
      @hero_photo2 = @hero_page.photos[1]
    end
  end

end
