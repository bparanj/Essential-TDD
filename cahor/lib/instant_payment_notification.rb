class InstantPaymentNotification
  attr_reader :notify

  include ActiveMerchant::Billing::Integrations

  def initialize(raw_post)
    @notify = Paypal::Notification.new(raw_post) 
  end
  
  def acknowledge
    @notify.acknowledge
  end
  
  # Only unique transactions are processed (txn_id store processed only once)
  def process_payment
    return if Payment.previously_processed?(@notify.transaction_id)  
    return if User.spoofed_receiver_email?(@notify['invoice'], @notify.account)      	
    
    if @notify.complete? 
      if Payment.transaction_has_correct_amount?(@notify.transaction_id)
        process_bounty
      else
        PaypalLogger.error("FRAUD ALERT : Payment transaction amount does not match #{@notify.to_yaml}")
      end
    else
      process_refund if refund?
    end
  end
  
  def handle_new_transaction(transaction_id)
    if Payment.new_transaction?(transaction_id)
      Payment.create(transaction_id: transaction_id, 
                     amount: @notify.amount,
                     payment_method: 'Paypal',
                     description: @notify.params['item_name'],
                     payer_id: @notify.params['payer_id'],
                     status: @notify.status,
                     test: @notify.test?,
                     gross: @notify.gross, 
                     currency: @notify.currency,
                     payer_email: @notify.params['payer_email'],
                     details: @notify.params,
                     invoice: @notify.invoice)
    end
  end

  private
  # Check if amount matches transaction on our site
  def process_refund
    payment = Payment.find_by_tranasction_id(@notify.transaction_id)
    if payment.has_correct_amount?
      Refund.create(transaction_id: @notify.transaction_id, amount: amount, currency: @notify.currency)
    else
      PaypalLogger.error("FRAUD ALERT : Refund amount does not match the transaction amount on the site.")
    end
  end
  # mc_gross - Full amount of the customer's payment, before transaction 
  # fee is subtracted. Equivalent to payment_gross for USD payments. If this
  # amount is negative, it signifies a refund or reversal, and either of those payment 
  # statuses can be for the full or partial amount of the original transaction.  
  # TODO : Can partial refund happen in our case? How to handle partial refund? 
  def refund?
    @notify.status == Payment::REFUNDED  
  end
  # I think this ActiveMerchant gives this as a string. 
  # TODO : Convert string to numeric then take abs.
  def refund_amount
    @notify.gross.abs
  end
  # create_bounty & credit affiliate, record the product price at the time of purchase not current price.  
  def process_bounty
    transaction_id = transaction.details['transaction_id']
    order = Order.find_by_transaction_id(transaction_id)
    referrer_code = order.details['custom']
    
    if referrer_code
      affiliate = Affiliate.find_by_referrer_code(referrer_code)
      # TODO : product_price is decimal. Test it is stored correctly.
      if affiliate
        Bounty.create(affiliate_id: affiliate.id, product_price: @notify.gross)
      else
        PaypalLogger.error("FRAUD ALERT : Could not create bounty. Affiliate not found for referrer_code : #{referrer_code}.")
      end
    end
  end
end
