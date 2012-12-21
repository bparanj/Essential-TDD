class Product < ActiveRecord::Base
  attr_accessible :price, :name, :remove_file, :file
  belongs_to :user
  
  mount_uploader :file, FileUploader
  
  def self.price_in_cents(product_id)
    product = find(product_id)
    product.price * 100
  end
end
