class PaypalNotificationMapper
  include ActiveMerchant::Billing::Integrations

  def initialize(raw_post)
    @notify = Paypal::Notification.new(raw_post) 
  end  
  
  def item_name
    @notify.params['item_name']
  end

  def item_number
    @notify.params['item_number']
  end
  
  def payer_id
    @notify.params['payer_id']
  end
                
  def payer_email
    @notify.params['payer_email']
  end
  
  def complete?
    @notify.complete? 
  end
  
  def transaction_id
    @notify.transaction_id
  end

  def amount
    @notify.amount
  end
  
  def status
    @notify.status
  end

  def test?
    @notify.test?
  end
  
  def gross
    # This is the right one to use instead of notify.amount
    @notify.gross
  end
  
  def currency
    @notify.currency
  end
  
  def params
    @notify.params
  end
  
  def invoice
    @notify.invoice
  end

  def acknowledge
    @notify.acknowledge
  end

  def account
    @notify.account
  end

end
