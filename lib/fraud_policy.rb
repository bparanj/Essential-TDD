class FraudPolicy
  
  def initialize(notify, transaction, order)
    @notify = notify
    @transaction = transaction
    @order = order
  end  
  
  def spoofed_receiver_email?
    User.spoofed_receiver_email?(@notify.invoice, @notify.account)      	
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
