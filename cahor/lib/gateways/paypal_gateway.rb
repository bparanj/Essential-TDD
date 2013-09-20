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
  
  def self.set_express_checkout(amount, options = {})
    token = Token.create!
    @confirmation_number = token.confirmation_number
    response = ZephoPaypalExpress.setup_purchase(amount,
                                                 ip: options[:ip],
                                                 return_url: options[:return_url],
                                                 cancel_return_url: options[:cancel_return_url],
                                                 notify_url: options[:notify_url],
                                                 order_id: @confirmation_number,
                                                 custom: options[:custom])    
    PaypalLogger.info("set_express_checkout response : #{response.to_yaml}") unless response.success?
    response
  end
          
  def self.checkout(ip_address, options = {})        
    order = Order.new(express_token: options[:express_token], 
                      express_payer_id: options[:express_payer_id],
                      product_id: options[:product_id],
                      item_name: options[:item_name])    
    order.ip_address = ip_address
    order.number = @confirmation_number
        
    response = do_express_checkout_payment(options[:amount], 
                                           ip: order.ip_address,
                                           token: order.express_token,
                                           payer_id: order.express_payer_id,
                                           items: payment_details(options))

    if response.success?
       order.mark_ready_for_fulfillment
    else
       order.mark_as_failed
    end    
                                          
    checkout_response = get_express_checkout_details(order.express_token)
    if checkout_response.success?
      checkout_mapper = BillingResponseMapper.new(checkout_response)
      order.buyer_email = checkout_mapper.email
      order.first_name = checkout_mapper.first_name
      order.last_name = checkout_mapper.last_name
      order.custom = checkout_mapper.custom
      order.details = checkout_mapper.details  
    else
      PaypalLogger.error("get_express_checkout_details failed response : #{checkout_response.to_yaml}")         
    end
    order.save!
    order.create_purchase_transaction(options[:amount], response)
    
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
      PaypalLogger.info 'Purchase success. Allow user to download the book.'
    else
      PaypalLogger.info("Purchase failed. Response is : #{response.to_yaml}")
    end
    response
  end
  # Send the right values to Paypal, so that IPN class can do fraud check by checking 
  # the order with the Paypal posted variables.
  def self.payment_details(options)
    items = []
    details = {}
    details['name'] = options[:item_name]
    details['number'] = options[:product_id]

    items << details
  end
end