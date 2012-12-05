class OrdersController < ApplicationController
  # http://localhost:3010/orders/new?token=EC-6JK45894P8656060H&PayerID=R6TPVW2ZMCR9Q
  def new
    @order = Order.new(express_token: params[:token], 
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
    response = ZephoPaypalExpress.setup_purchase(product_price_in_cents,
                 ip: request.remote_ip,
                 return_url: new_order_url,
                 cancel_return_url: welcome_url,
                 callback_url: sales_url)
      
    redirect_to ZephoPaypalExpress.redirect_url_for(response.token)
  end
  
  def product_price_in_cents
    100
  end
end
