class OrdersController < ApplicationController
  # http://localhost:3010/orders/new?token=EC-6JK45894P8656060H&PayerID=R6TPVW2ZMCR9Q
  def new
    result, @order = PaypalGateway.checkout(request.remote_ip,
                                            express_token: params[:token],
                                            express_payer_id: params[:PayerID],
                                            amount: amount,
                                            product_id: session[:product_id])
    if result.success?
      ProductMailer.confirmation_email(@order).deliver
      
      render action: 'success'
    else
      # TODO : Email the admin about order processing failure with details
      render action: 'failure'
    end    
    session[:product_id] = nil
  end
  
  def express
    session[:product_id] = params[:product_id]
    response = PaypalGateway.set_express_checkout(amount,
                                                  ip: request.remote_ip,
                                                  return_url: new_order_url,
                                                  cancel_return_url: welcome_url,
                                                  notify_url: sales_url,
                                                  custom: cookies.signed[:referral_code])
          
    redirect_to PaypalGateway.redirect_url_for(response.token)
  end
  
  private
  
  def amount
    Product.price_in_cents(session[:product_id])
  end
end
