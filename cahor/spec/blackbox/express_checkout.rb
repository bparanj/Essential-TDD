require 'capybara'
require 'capybara/dsl'
require 'capybara-webkit'

Capybara.default_driver = :webkit

class Buyer
  include Capybara::DSL

  def checkout
    p 'Visiting home page'
    # visit('http://www.google.com')
    # p find_link('News').visible?
    visit('http://localhost:3020')
    p 'Buying now'
    click_link('Btn_xpresscheckout')
    p 'Logging In'
    find(:xpath, "//input[@id='login_email']").set "amy_1342401985_per@gmail.com"
    # fill_in 'login_email', :with => ''
    fill_in 'login_password', :with => "342401932"
    
    p 'done.'
  end
end

buyer = Buyer.new
buyer.checkout
