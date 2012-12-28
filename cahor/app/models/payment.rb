require 'money'

class Payment < ActiveRecord::Base
  attr_accessible :transaction_id, :amount, :payment_method, :description, :payer_id, :status, :test, :gross, :currency, :payer_email, :details, :invoice
  # This happened on third-party payment processing site
  
  COMPLETE = 'Completed'
  PENDING = 'Pending'
  REFUNDED = 'Refunded'
                
  def complete?
    self.status == COMPLETE
  end
end