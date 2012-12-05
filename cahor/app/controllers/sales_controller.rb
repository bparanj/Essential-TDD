class SalesController < ApplicationController
  protect_from_forgery :except => [:create] 
  
  # TODO: Do we need product_id? Should not be hard coded
  def create
    Sale.create!(params: params, 
                 invoice: params[:invoice],
                 status: params[:payment_status], 
                 transaction_id: params[:txn_id],
                 product_id: 1)
    
    render nothing: true
  end
end