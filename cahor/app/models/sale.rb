class Sale < ActiveRecord::Base
  belongs_to :product
  attr_accessible :params, :status, :transaction_id, :invoice, :product_id
  serialize :params
  
end
