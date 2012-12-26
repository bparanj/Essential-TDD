class LandingPage < ActiveRecord::Base
  attr_accessible :link, :name, :product_id
  
  validates_presence_of :name, :link
  
  belongs_to :product
  # TODO: Create a before save to strip out http:// in the link
end
