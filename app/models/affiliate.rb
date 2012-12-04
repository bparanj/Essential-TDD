class Affiliate < ActiveRecord::Base
  attr_accessible :user_id, :referrer_code
  
  has_many :payables
  has_many :payouts
  
  before_create :populate_referrer_code
  
  def populate_referrer_code
    code = Referral.code
    while Affiliate.find_by_referrer_code(code) != nil
      code = Referral.code
    end
    self.referrer_code = code
  end
  
end
