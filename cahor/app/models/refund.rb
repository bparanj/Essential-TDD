class Refund < ActiveRecord::Base
  attr_accessible :transaction_id, :amount, :currency
end
