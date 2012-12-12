class Token < ActiveRecord::Base
  validates_uniqueness_of :confirmation_number
  before_create :generate_order_confirmation_number
  
  def generate_order_confirmation_number
    record = true
    while record
      random = "R#{Array.new(9){rand(9)}.join}"
      record = self.class.where(:number => random).first
    end
    self.confirmation_number = random if self.confirmation_number.blank?
  end

end
