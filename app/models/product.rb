class Product < ActiveRecord::Base
  attr_accessible :price, :name
  belongs_to :user
  
  has_many :sales
  
  def self.price_in_cents(product_id)
    product = find(product_id)
    product.price * 100
  end
end
