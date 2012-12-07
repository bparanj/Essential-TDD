class HomeController < ApplicationController
  
  def index
    @product = Product.first
  end
end
