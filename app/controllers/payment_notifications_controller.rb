class PaymentNotificationsController < ApplicationController
  protect_from_forgery :except => [:create]
    
  def create
    ipn = InstantPaymentNotification.new(request.raw_post)

    if ipn.acknowledge
      ipn.process_payment
    else 
      PaypalLogger.info("Received an INVALID response, either you have done something wrong or the original IPN should be treated as suspicious and investigated : #{request.raw_post}")
    end

    render :text => '', :status => :no_content  
  end
  
end