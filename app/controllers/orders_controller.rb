class OrdersController < ApplicationController
  # http://localhost:3010/orders/new?token=EC-6JK45894P8656060H&PayerID=R6TPVW2ZMCR9Q
  def new
    result = PaypalGateway.checkout(request.remote_ip,
                                    express_token: params[:token],
                                    express_payer_id: params[:PayerID],
                                    amount: amount)
    if result.success?
      render action: 'success'
    else
      render action: 'failure'
    end    
  end
  
  def express
    response = PaypalGateway.set_express_checkout(amount,
                                                  ip: request.remote_ip,
                                                  return_url: new_order_url,
                                                  cancel_return_url: welcome_url,
                                                  notify_url: sales_url,
                                                  custom: 'COOKIE-VALUE-GOES-HERE')
          
    redirect_to PaypalGateway.redirect_url_for(response.token)
  end
  
  private
  
  def amount
    # load current_product from session and return its price in cents
    100
  end
end
