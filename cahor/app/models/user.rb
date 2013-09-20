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
  
  
end