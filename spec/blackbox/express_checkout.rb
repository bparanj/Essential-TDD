require 'capybara'
require 'capybara/dsl'
require 'capybara-webkit'

Capybara.default_driver = :webkit

class Buyer
  include Capybara::DSL

  def checkout
    p 'Visiting home page'
    visit('http://localhost:3020')
    p 'Buying now'
    click_link('Btn_xpresscheckout')
    p 'done.'
  end
end

buyer = Buyer.new
buyer.checkout
