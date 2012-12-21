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
  
  %w(complete? transaction_id amount status test? gross currency params invoice acknowledge account).each do |m|
     class_eval %(
       def #{m}
         (@notify.send(:#{m}))
       end
     )
  end
  
  # This is the right one to use instead of notify.amount
  # def gross
  #   @notify.gross
  # end
end
