class Order < ActiveRecord::Base
  attr_accessible :express_token, :express_payer_id, :product_id, :status
  attr_protected :ip_address
  serialize :details

  belongs_to :product
  has_many :transactions
  
  validates_uniqueness_of :number
  
  PURCHASE = 'purchase'
  FULFILL = 'fulfill'
      
  def mark_ready_for_fulfillment
    self.status = FULFILL
    save
  end
  
end
