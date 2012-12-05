class SalesController < ApplicationController
  protect_from_forgery :except => [:create] 

  def create
    Sale.create!(params: params, 
                 invoice: params[:invoice],
                 status: params[:payment_status], 
                 transaction_id: params[:txn_id])
    
    render nothing: true
  end
end