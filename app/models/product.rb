class Product < ActiveRecord::Base
  attr_accessible :price, :name, :file, :sales_page, :thanks_page, :cancel_page
  validates_presence_of :name, :price, :sales_page
  
  has_many :landing_pages, :dependent => :destroy
  belongs_to :user
  
  mount_uploader :file, FileUploader
  
  def self.price_in_cents(id)
    product = find(id)
    product.price * 100
  end
end
