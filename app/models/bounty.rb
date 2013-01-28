class Bounty < ActiveRecord::Base
  attr_accessible :affiliate_id, :product_price, :currency
  
  belongs_to :affiliate
  belongs_to :payable
end
