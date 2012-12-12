class Order < ActiveRecord::Base
  attr_accessible :express_token, :express_payer_id, :product_id, :status
  attr_protected :ip_address
  serialize :details

  belongs_to :product
  has_many :transactions
  
  PURCHASE = 'purchase'
  
  def self.generate_order_number
    random = ''
    record = true
    while record
      random = "R#{Array.new(9){rand(9)}.join}"
      record = Order.where(:number => random).first
    end
    random
  end
    
  def self.mark_ready_for_fulfillment(id)
    order = find(id)
    order.status = 'fulfill'
    save
  end
  
end
