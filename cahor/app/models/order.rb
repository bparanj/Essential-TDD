class Order < ActiveRecord::Base
  attr_accessible :express_token, :express_payer_id
  attr_protected :ip_address
  serialize :details

  belongs_to :product
  has_many :transactions
  
  PURCHASE = 'purchase'

  def product_price
    # TODO: product.price_in_cents
    100
  end
  
end
