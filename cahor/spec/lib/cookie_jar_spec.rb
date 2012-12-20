require 'spec_helper'

class BogusCookie 
  
  def initialize(cookies)
    @cookies = cookies
  end
  
  def signed
    @cookies
  end
  
  def []=(y, value)
    @cookies[y] = value
  end
  
  def cookies
    self
  end
end

describe CookieJar do
  specify 'If the referral code is not set then it is a first time visit' do
    cookies = BogusCookie.new({})
    cookie_manager = CookieJar.new(cookies)
    
    cookie_manager.should be_first_time_visit
  end

  specify 'If the referral code is set then it is NOT a first time visit' do
    cookies = BogusCookie.new({})
    cookie_manager = CookieJar.new(cookies)
    cookie_manager.set_referral_cookie('xyz')
    
    cookie_manager.should_not be_first_time_visit
  end

  specify 'The referral code is set in the signed cookie and expires in 180 days from now' do
    cookies = BogusCookie.new({})
    cookie_manager = CookieJar.new(cookies)
    cookie_manager.set_referral_cookie('xyz')
    
    cookies.signed[:referral_code][:value].should == 'xyz'
    cookies.signed[:referral_code][:expires].usec.should be < 180.days.from_now.usec
  end
  
  specify 'The payer_cookie must be set with a unique cookie that expires in 180 days from now' do
    cookie_jar = BogusCookie.new({})
    cookie_manager = CookieJar.new(cookie_jar)
    cookie_manager.set_payer_cookie
    
    cookie_jar.cookies.signed[:payer_cookie][:value].size.should be > 4
    cookie_jar.cookies.signed[:payer_cookie][:expires].usec.should be < 180.days.from_now.usec
  end
end