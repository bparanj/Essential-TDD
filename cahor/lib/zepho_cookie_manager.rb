class ZephoCookieManager
  
  def initialize(cookies)
    @cookies = cookies
  end
  
  def set_referral_cookie(referral_code)
    @cookies.signed[:referral_code] = { :value => referral_code, :expires => 180.days.from_now }
  end
  
  def set_payer_cookie
    @cookies[:payer_cookie] = { :value => _generate_token, :expires => 180.days.from_now }
  end
  
  def first_time_visit?
    @cookies.signed[:referral_code].nil?
  end

  private 
  
  def _generate_token        
    loop do           
      token = SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz') 
      break token unless Click.find_by_payer_cookie(token)         
    end       
  end
end