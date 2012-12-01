class Payable < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :payout
  belongs_to :affiliate
  belongs_to :product
  
end
