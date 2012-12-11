class PaypalGateway
  # ** Paypal API **
  # SetExpressCheckout (required): Initiates an Express Checkout transaction
  # GetExpressCheckoutDetails (optional): Retrieves buyer details about an Express Checkout transaction
  # DoExpressCheckoutPayment (required): Completes an Express Checkout transaction
  
  # ** ActiveMerchant API **
  # def setup_purchase(money, options = {})
  #   'SetExpressCheckout'
  # end
  # 
  # def details_for(token)
  #   'GetExpressCheckoutDetails'
  # end
  # 
  # def purchase(money, options = {})
  #   'DoExpressCheckoutPayment'
  # end
  
  # Custom field Character length and limitations: 256 single-byte alphanumeric characters  
  def self.set_express_checkout(amount, options = {})
    @confirmation_number = Order.generate_order_number
    response = ZephoPaypalExpress.setup_purchase(amount,
                                                 ip: options[:ip],
                                                 return_url: options[:return_url],
                                                 cancel_return_url: options[:cancel_return_url],
                                                 notify_url: options[:notify_url],
                                                 order_id: @confirmation_number,
                                                 custom: options[:custom])    
    Rails.logger.info("set_express_checkout response : #{response.to_yaml}") unless response.success?
    response
  end
          
  def self.checkout(ip_address, options = {})        
    order = Order.new(express_token: options[:express_token], 
                      express_payer_id: options[:express_payer_id],
                      product_id: options[:product_id])    
    order.ip_address = ip_address
    order.number = @confirmation_number
    
    response = do_express_checkout_payment(options[:amount], 
                                           ip: order.ip_address,
                                           token: order.express_token,
                                           payer_id: order.express_payer_id)
                                           
    checkout_response = get_express_checkout_details(order.express_token)
    if checkout_response.success?
      order.buyer_email = checkout_response.email
      order.first_name = checkout_response.params['first_name']
      order.last_name = checkout_response.params['last_name']
      order.details = checkout_response.params      
    end
    order.save!
    order.transactions.create!(action: Order::PURCHASE, 
                               amount: options[:amount], 
                               response: response)
    [response, order]
  end    
      
  def self.redirect_url_for(token)
    ZephoPaypalExpress.redirect_url_for(token)
  end
  
  private
  
  def self.get_express_checkout_details(token)
    ZephoPaypalExpress.details_for(token)
  end
  
  def self.do_express_checkout_payment(amount, options = {})
    response = ZephoPaypalExpress.purchase(amount, 
                                           ip: options[:ip], 
                                           token: options[:token], 
                                           payer_id: options[:payer_id])
    if response.success?
      Rails.logger.info 'Purchase success. Allow user to download the book.'
    else
      Rails.logger.info("Purchase failed. Response is : #{response.to_yaml}")
    end
    response
  end
    
end
