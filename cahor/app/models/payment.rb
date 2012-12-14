require 'money'

class Payment < ActiveRecord::Base
  attr_accessible :currency, :gross, :transaction_id
  
  COMPLETE = 'Completed'
  PENDING = 'Pending'
  
  def has_correct_amount?
    transaction = Transaction.find_by_transaction_id(self.transaction_id)
    paid_gross = transaction.details['gross_amount']
    paid_currency = transaction.details['gross_amount_currency_id']
    
    paid = Money.new(BigDecimal.new(paid_gross), paid_currency)
    price = Money.new(self.gross, self.currency)
    price == paid
  end
  
  def self.previously_processed?(transaction_id)
    return false if new_transaction?(transaction_id)
    payment = find_by_transaction_id(transaction_id)
    payment.complete? 
  end
  
  # Verify that the price, item description, and so on, match the transaction on your website.
  # Verify that the payment amount actually matches what you intend to charge.
  # This check provides additional protection against fraud.
  def self.transaction_has_correct_amount?(transaction_id)
    payment = find_by_transaction_id(transaction_id)
    payment.has_correct_amount?
  end
    
  def self.new_transaction?(transaction_id)
    payment = find_by_transaction_id(transaction_id)
    payment.nil?
  end
    
  def self.existing_incomplete_transaction?(transaction_id)
    !previously_processed?
  end
    
  def complete?
    self.status == COMPLETE
  end
end

# Payment
# - order_id
