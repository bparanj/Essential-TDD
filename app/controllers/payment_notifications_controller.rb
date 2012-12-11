class PaymentNotificationsController < ApplicationController
  protect_from_forgery :except => [:create]
  
  # TODO : Should the invoice be changed to order_id ? Check it by testing the checkout process manually.
  # def create
  #   PaymentNotification.create!(details:        params, 
  #                               invoice:        params[:invoice], 
  #                               status:         params[:payment_status], 
  #                               transaction_id: params[:txn_id])
  #   render nothing: true
  # end
  
  def create
    ipn = InstantPaymentNotification.new(request.raw_post)

    if ipn.acknowledge
      ipn.handle_new_transaction
      ipn.process_payment
    else
      PaypalLogger.info("Failed to verify Paypal IPN notification, please investigate : #{request.raw_post}")
    end

    render :text => '', :status => :no_content  
  end
  
end