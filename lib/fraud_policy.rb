class FraudPolicy
  
  def initialize(notify, transaction, order)
    @notify = notify
    @transaction = transaction
    @order = order
  end  
  
  # Validate that the receiver’s email address is registered to you.
  # This check provides additional protection against fraud.
  def spoofed_receiver_email?
    confirmation_number = @notify.invoice
    receiver_email = @notify.account
    
    order = Order.find_by_confirmation_number(confirmation_number)
    seller_email = order.product.user.primary_paypal_email
    seller_email != receiver_email
  end
  
  def no_fraudulent_change?
    (payment_has_correct_amount? &&  no_malicious_price_change?)
  end
          
  # Verify that the price, item description, and so on, match the transaction on your website.
  # This check provides additional protection against fraud.
  def payment_has_correct_amount?
    actual_gross = @transaction.amount
    actual_currency = @transaction.currency
    actual = Money.new(actual_gross, actual_currency)
    paid = Money.new(BigDecimal.new(@notify.gross), @notify.currency)
    actual == paid
  end
   
  private
          
  def no_malicious_price_change?
    (@order.product_id == @notify.item_number) && (@order.product.name == @notify.item_name)
  end

end
