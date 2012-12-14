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
        Order.mark_ready_for_fulfillment(@notify.item_id)
        # create_bounty 
        # credit Affiliate
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
  
  def process_refund
    # mc_gross - Full amount of the customer's payment, before transaction 
    # fee is subtracted. Equivalent to payment_gross for USD payments. If this
    # amount is negative, it signifies a refund or reversal, and either of those payment 
    # statuses can be for the full or partial amount of the original transaction.
    
      # if amount does not exceed transaction on our site
      #   then create refund
      # if @notify.gross 
  end
  
  def refund?
    @notify.status == Payment::REFUNDED  
  end

end
  



