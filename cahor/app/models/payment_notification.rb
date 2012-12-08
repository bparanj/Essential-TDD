class PaymentNotification < ActiveRecord::Base
  attr_accessible :details, :invoice, :status, :transaction_id
  # TODO: rename invoice to order_id and add belongs_to :order
end
