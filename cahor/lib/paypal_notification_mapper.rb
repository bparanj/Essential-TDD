class PaypalNotificationMapper
  include ActiveMerchant::Billing::Integrations

  def initialize(raw_post)
    @notify = Paypal::Notification.new(raw_post) 
  end  
  
  %w(item_name item_number payer_id payer_email).each do |m|
     class_eval %(
       def #{m}
         (@notify.params['#{m}'])
       end
     )
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
