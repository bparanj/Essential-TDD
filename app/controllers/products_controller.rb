class ProductsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @products = current_user.products
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.new(params[:product])
    @product.user_id = current_user.id
    
    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      render action: "new" 
    end
  end

  def update
    @product = Product.find(params[:id])

    if @product.update_attributes(params[:product])
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    redirect_to products_url
  end
end
