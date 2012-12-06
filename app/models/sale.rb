class Sale < ActiveRecord::Base
  belongs_to :product
  attr_accessible :details, :status, :transaction_id, :invoice, :product_id
  serialize :details
  
end
