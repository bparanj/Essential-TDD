class Product < ActiveRecord::Base
  attr_accessible :amount, :name
  belongs_to :user
  
  has_many :sales
end
