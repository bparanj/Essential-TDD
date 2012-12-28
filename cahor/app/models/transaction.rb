class Transaction < ActiveRecord::Base
  attr_accessible :action, :amount, :authorization, :message, :order_id, :details, :success, :action, :amount, :response, :transaction_id
  belongs_to :order
  serialize :details
  # This is the transaction that happened on our site.
  
  def response=(response)
    self.success = response.success?
    self.authorization = response.authorization
    self.message = response.message
    self.transaction_id = response.params['transaction_id']
    self.currency = response.params['gross_amount_currency_id']
    self.details = response.params    
  rescue ActiveMerchant::ActiveMerchantError => e
    self.success = false
    self.authorization = nil
    self.transaction_id = 0
    self.message = e.message
    self.details = {}    
  end
  
  def previously_processed?
    return false if new_payment?
    payment.complete?
  end
        
  def new_payment?
    payment = Payment.find_by_transaction_id(self.transaction_id)
    payment.nil?
  end
end
