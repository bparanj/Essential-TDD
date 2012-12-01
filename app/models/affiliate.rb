class Affiliate < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :payables
  has_many :payouts
  
end
