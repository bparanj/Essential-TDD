class PaymentNotificationsController < ApplicationController
  protect_from_forgery :except => [:create]
    
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