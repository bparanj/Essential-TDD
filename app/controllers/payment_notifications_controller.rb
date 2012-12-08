class PaymentNotificationsController < ApplicationController
  protect_from_forgery :except => [:create]
  
  # TODO : Should the invoice be changed to order_id ? Check it by testing the checkout process manually.
  def create
    PaymentNotification.create!(details:        params, 
                                invoice:        params[:invoice], 
                                status:         params[:payment_status], 
                                transaction_id: params[:txn_id])
    render nothing: true
  end
end