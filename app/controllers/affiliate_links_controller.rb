class AffiliateLinksController < ApplicationController

  def index
    @products = Product.all
  end

  def show    
    @product = Product.find(params[:id])
    @landing_pages = @product.landing_pages
    @affiliate_link = Affiliate.link(current_user, params[:id])
  end
  
end
