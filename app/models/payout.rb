class Payout < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :affiliate
  has_many :payables
  
  # TODO : Refund has transaction id, transaction has order id, order has custom field (affiliate referrer code)
  def owed
    # Subtract all refund amounts to calculate the payout amount
  end
end
