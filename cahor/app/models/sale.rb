class Sale < ActiveRecord::Base
  attr_accessible :details, :status, :transaction_id, :invoice
  serialize :details
  
end
