class Order < ActiveRecord::Base
  attr_accessible :express_token, :express_payer_id, :product_id
  attr_protected :ip_address
  serialize :details

  belongs_to :product
  has_many :transactions
  
  before_validation :generate_order_number, :on => :create
  
  PURCHASE = 'purchase'
  
  def generate_order_number
    record = true
    while record
      random = "R#{Array.new(9){rand(9)}.join}"
      record = self.class.where(:number => random).first
    end
    self.number = random if self.number.blank?
    self.number
  end
end
