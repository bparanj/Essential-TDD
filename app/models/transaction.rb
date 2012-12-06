class Transaction < ActiveRecord::Base
  attr_accessible :action, :amount, :authorization, :message, :order_id, :details, :success, :action, :amount, :response
  belongs_to :order
  serialize :details
  
  def response=(response)
    self.success = response.success?
    self.authorization = response.authorization
    self.message = response.message
    self.details = response.params
  rescue ActiveMerchant::ActiveMerchantError => e
    self.success = false
    self.authorization = nil
    self.message = e.message
    self.details = {}    
  end
end
