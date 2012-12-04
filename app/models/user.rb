class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :remember_me
  
  has_many :products
  has_one :affiliate
    
  def is_affiliate?
    affiliate = Affiliate.find_by_user_id(id)
    !affiliate.nil?
  end
  
end
