class SalesController < ApplicationController
  protect_from_forgery :except => [:create] 
  
  def create
    Sale.create!(details: params, 
                 invoice: params[:invoice],
                 status: params[:payment_status], 
                 transaction_id: params[:txn_id])
    
    render nothing: true
  end
end

# Paypal variables posted:
# "custom=89CVZ&mc_gross=500.00&address_status=confirmed&payer_id=EVMXCLDZJV77Q&tax=0.00
# &address_street=164+Waverley+Street&payment_date=15%3A23%3A54+Apr+15%2C+2005+PDT&payment_status=Completed
# &address_zip=K2P0V6&first_name=Tobias&mc_fee=15.05&address_country_code=CA&address_name=Tobias+Luetke&
# notify_version=1.7&payer_status=unverified&business=tobi%40leetsoft.com&address_country=Canada&
# address_city=Ottawa&quantity=1&payer_email=tobi%40snowdevil.ca&
# verify_sign=AEt48rmhLYtkZ9VzOGAtwL7rTGxUAoLNsuf7UewmX7UGvcyC3wfUmzJP&txn_id=6G996328CK404320L&
# payment_type=instant&last_name=Luetke&address_state=Ontario&receiver_email=tobi%40leetsoft.com&
# payment_fee=&receiver_id=UQ8PDYXJZQD9Y&txn_type=web_accept&item_name=Store+Purchase&
# mc_currency=CAD&test_ipn=1&payment_gross=&shipping=0.00"
