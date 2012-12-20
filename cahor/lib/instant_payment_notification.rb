class InstantPaymentNotification

  def initialize(raw_post)
    @notify = PaypalNotificationMapper.new(raw_post) 
    @payment = Payment.find_by_transaction_id(@notify.transaction_id)
    @transaction = Transaction.find(@notify.transaction_id)
    @order = @transaction.order
    @fraud_policy = FraudPolicy.new(@notify, @transaction, @order)
  end  
  
  # Only unique transactions are processed (txn_id store processed only once)
  def process_payment
    return if @transaction.previously_processed?
    
    if @fraud_policy.spoofed_receiver_email?
      PaypalLogger.error("FRAUD ALERT : Receiver email spoof for #{@notify.to_yaml}")
      return 
    end
    
    create_payment if @transaction.new_payment?
      
    begin
      if @notify.complete? 
        if @fraud_policy.no_fraudulent_change?
          run_bounty_processor
        else
          @order.set_fraud_alert
          PaypalLogger.error("FRAUD ALERT : Payment transaction amount does not match #{@notify.to_yaml}")
        end
      else
        run_refund_processor
      end
    rescue => e
      ZephoLogger.error('Failed to process payment due to : ', e, PaypalLogger)
    end
  end
    
  def acknowledge
    @notify.acknowledge
  end

  private
  
  # TODO : notify.amount and notify.gross are the same. Delete one of these fields after testing.
  # Note : payment_gross ipn variable is a deprecated field. mc_gross must be used.
  def create_payment
    Payment.create(transaction_id: @notify.transaction_id, 
                   amount: @notify.amount,
                   payment_method: 'Paypal',
                   description: @notify.item_name,
                   payer_id: @notify.payer_id,
                   status: @notify.status,
                   test: @notify.test?,
                   gross: @notify.gross, # This is the right one to use instead of notify.amount
                   currency: @notify.currency,
                   payer_email: @notify.payer_email,
                   details: @notify.params,
                   invoice: @notify.invoice)
  end
      
  def run_refund_processor
    refund_processor = RefundProcessor.new(@notify, @fraud_policy)
    refund_processor.run
  end
  
  def run_bounty_processor
    bounty_processor = BountyProcessor.new(@notify, @order)
    bounty_processor.run
  end
end
