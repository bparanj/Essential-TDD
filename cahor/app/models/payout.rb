class Payout < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :affiliate
  has_many :payables
  
end
