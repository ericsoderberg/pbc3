class HyperHomeController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.pjs
    end
  end
end
