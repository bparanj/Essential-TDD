class Click < ActiveRecord::Base
  attr_accessible :referral_code, :product_id, :landing_page_id, :referral_cookie, :payer_cookie, :domain, :ip_address
end


                               