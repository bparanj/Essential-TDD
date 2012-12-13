class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :remember_me
  
  has_many :products
  has_one :affiliate, dependent: :destroy
  
  validates_length_of :primary_paypal_email, :maximum => 127
      
  def is_affiliate?
    !self.affiliate.nil?
  end
  
  # Validate that the receiver’s email address is registered to you.
  # This check provides additional protection against fraud.
  def self.spoofed_receiver_email?(confirmation_number, receiver_email)
    order = Order.find_by_confirmation_number(confirmation_number)
    seller_email = order.product.user.primary_paypal_email
    seller_email != receiver_email
  end
  
end