class Bounty < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :affiliate
  # belongs_to :paypal_notification
  belongs_to :payable
end
