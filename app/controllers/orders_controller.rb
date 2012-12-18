class OrdersController < ApplicationController
  # http://localhost:3010/orders/new?token=EC-6JK45894P8656060H&PayerID=R6TPVW2ZMCR9Q
  def new
    begin
      result, @order = PaypalGateway.checkout(request.remote_ip,
                                              express_token: params[:token],
                                              express_payer_id: params[:PayerID],
                                              amount: amount,
                                              product_id: session[:product_id])
      if result.success?        
        render action: 'success'
      else
        PaypalLogger.error("Checkout failed for order : #{@order}.")
        
        render action: 'failure'
      end    

      session[:product_id] = nil
    rescue Exception => e
      ZephoLogger.error("ORDER ERROR : Unable to process order due to : ", e, PaypalLogger)      
    end
  end
  
  def express
    session[:product_id] = params[:product_id]
        
    response = PaypalGateway.set_express_checkout(amount,
                                                  ip: request.remote_ip,
                                                  return_url: new_order_url,
                                                  cancel_return_url: welcome_url,
                                                  notify_url: payment_notifications_url,
                                                  custom: cookies.signed[:referral_code])
          
    redirect_to PaypalGateway.redirect_url_for(response.token)
  end
  
  private
  
  def amount
    Product.price_in_cents(session[:product_id])
  end
end