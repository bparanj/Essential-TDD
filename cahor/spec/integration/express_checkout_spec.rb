require 'spec_helper'

feature 'buyer puchases a product' do
  scenario 'successfully completes a Paypal express checkout' do
    visit some_path pointing to the product page containing paypal buy now button
    click_link "Buy Now"
    fill_in "email", with: "amy@zepho.com"
    fill_in "password", with: '8387837'
    click_button 'Continue'
    check 'Agree'
    click_button 'Buy'
    
  end
end

bundle exec rspec spec/integration/express_checkout_spec.rb -f documentation