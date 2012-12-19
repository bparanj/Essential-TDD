class RefundProcessor
  def initialize(notify, fraud_policy)
    @fraud_policy = fraud_policy 
    @notify = notify
  end
  
  def run
    process_refund if refund?
  end
  
  private
  # Check if amount matches transaction on our site
  def process_refund
    if @fraud_policy.payment_has_correct_amount?
      Refund.create(transaction_id: @notify.transaction_id, amount: refund_amount, currency: @notify.currency)
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
end