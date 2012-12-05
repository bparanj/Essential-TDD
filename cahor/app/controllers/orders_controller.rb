class OrdersController < ApplicationController
  # http://localhost:3010/orders/new?token=EC-6JK45894P8656060H&PayerID=R6TPVW2ZMCR9Q
  def new
    @order = Order.new(express_token: params[:token], 
                       express_payer_id: params[:PayerID])    
    @order.ip_address = request.remote_ip
    
    if @order.save
      if @order.purchase
        response = ZephoPaypalExpress.details_for(express_token)
        if response.success?
          @order.buyer_email = response.email
          @order.first_name = response.params['first_name']
          @order.last_name = response.params['last_name']
          @order.details = response.params
          unless @order.save
            logger.error("Could not save order : #{@order.to_yaml} due to #{@order.errors.full_messages}")
            logger.error("Response of details_for call : #{response.to_yaml}")
          end
        else
          logger.error("Could not get details for order : #{@order.to_yaml}")
        end
        render action: 'success'
      else
        logger.error("Could not process order - purchase failed : #{@order.to_yaml}")
        render action: 'failure'
      end
    else
      logger.error("Could not save order : #{@order.to_yaml} due to #{@order.errors.full_messages}")
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
