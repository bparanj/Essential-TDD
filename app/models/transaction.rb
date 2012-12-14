class Transaction < ActiveRecord::Base
  attr_accessible :action, :amount, :authorization, :message, :order_id, :details, :success, :action, :amount, :response, :transaction_id
  belongs_to :order
  serialize :details
  
  def response=(response)
    self.success = response.success?
    self.authorization = response.authorization
    self.message = response.message
    self.transaction_id = response.params['transaction_id']
    self.details = response.params    
  rescue ActiveMerchant::ActiveMerchantError => e
    self.success = false
    self.authorization = nil
    self.transaction_id = 0
    self.message = e.message
    self.details = {}    
  end
end
