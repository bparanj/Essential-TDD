class LandingPage < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :product
  validates_presence_of :name, :link

end
