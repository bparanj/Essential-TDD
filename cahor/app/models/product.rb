class Product < ActiveRecord::Base
  attr_accessible :price, :name
  belongs_to :user
  
  # has_many :paypal_notifications Do you need this? Refer railscast.
  
  def self.price_in_cents(product_id)
    product = find(product_id)
    product.price * 100
  end
end
