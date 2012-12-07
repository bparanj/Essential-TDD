class Product < ActiveRecord::Base
  attr_accessible :price, :name
  belongs_to :user
  
  has_many :sales
end
