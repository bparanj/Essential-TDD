class Order < ActiveRecord::Base
  attr_accessible :express_token, :express_payer_id, :product_id
  attr_protected :ip_address
  serialize :details

  belongs_to :product
  has_many :transactions
  
  PURCHASE = 'purchase'
  
end
