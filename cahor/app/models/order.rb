class Order < ActiveRecord::Base
  attr_accessible :express_token, :express_payer_id, :product_id, :status, :item_name
  attr_protected :ip_address
  serialize :details

  belongs_to :product
  has_many :transactions
  
  validates_uniqueness_of :number
  
  PURCHASE = 'purchase'
  FULFILL = 'fulfill'
  FAILED = 'failed'
  FRAUD = 'fraud'
  
  def mark_ready_for_fulfillment
    self.status = FULFILL
  end
  
  def mark_as_failed
    self.status = FAILED
  end
  
  def set_fraud_alert
    self.status = FRAUD
    save
  end
end
