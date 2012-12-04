class Sale < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :product
end
