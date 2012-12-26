class LandingPagesController < ApplicationController

  def home
    @products = Product.all
  end
  
  def new
    _find_product
    @landing_page = LandingPage.new
  end
  # TODO : Format the validation error in the view (show in red box the validation errors)
  def create
    _find_product
    landing_page = LandingPage.new(params[:landing_page]) 
    if landing_page.valid?
      @product.landing_pages << landing_page
      flash[:notice] = "Successfully created landing page"    
    else
      flash[:error] = "Name and link are required for a landing page"
    end
    redirect_to @product
  end

  def edit
    _find_product
    _find_landing_page
  end

  def update
    _find_product
    _find_landing_page
    if @landing_page.update_attributes(params[:landing_page])
      flash[:notice] = "Landing Page updated successfully"
      redirect_to @product
    else
      flash[:error] = "Landing Page could not be updated."
      render :action => 'edit'
    end
  end

  def destroy
    _find_landing_page
    _find_product
    @landing_page.destroy
    flash[:notice] = "Successfully deleted landing page"
    redirect_to product_path(@product)
  end

  private

  def _find_product
    @product = Product.find(params[:product_id])
  end

  def _find_landing_page
    @landing_page = LandingPage.find(params[:id])
  end
end

