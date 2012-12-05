class OrdersController < ApplicationController
  # http://localhost:3010/orders/new?token=EC-6JK45894P8656060H&PayerID=R6TPVW2ZMCR9Q
  def new
    @order = current_cart.build_order(express_token: params[:token], 
                                      express_payer_id: params[:PayerID])    
    @order.ip_address = request.remote_ip
    
    if @order.save
      if @order.purchase
        render action: 'success'
      else
        render action: 'failure'
      end
    else
      render action: 'new'
    end
  end
  
  # Step 1 : Setup Express Checkout
  def express
    response = ZephoPaypalExpress.setup_purchase(current_cart.build_order.price_in_cents,
      ip: request.remote_ip,
      return_url: new_order_url,
      cancel_return_url: products_url)
      
    redirect_to ZephoPaypalExpress.redirect_url_for(response.token)
  end
end
