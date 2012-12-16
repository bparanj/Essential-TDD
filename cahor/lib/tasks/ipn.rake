
namespace :paypal do
  desc "Dump variables needed to simulate IPN notification"
  task :ipn => :environment do
    order = Order.last
    transaction = Transaction.last
    
    payer_id = order.details['payer_id']
    payer_status = order.details['payer_status']
    payer_email = order.details['payer']
    custom = order.details['custom']
    invoice_id = order.details['invoice_id']
    mc_gross = order.details['PaymentDetails']['OrderTotal']
    txn_id = order.details['transaction_id']
    receiver_email = order.details['primary_paypal_email']
    mc_currency = transaction.details['gross_amount_currency_id']
    
    ipn = {}
    ipn['payer_id'] = payer_id
    ipn['payer_status'] = payer_status
    ipn['payer_email'] = payer_email
    ipn['custom'] = custom
    ipn['invoice_id'] = invoice_id
    ipn['mc_gross'] = mc_gross
    ipn['mc_currency'] = mc_currency
    ipn['txn_id'] = txn_id
    ipn['receiver_email'] = receiver_email
   
    p ipn.to_query + '&address_status=confirmed&tax=0.00&address_street=164+Waverley+Street&payment_date=15%3A23%3A54+Apr+15%2C+2005+PDT&payment_status=Completed&address_zip=K2P0V6&first_name=Tobias&mc_fee=15.05&address_country_code=CA&address_name=Tobias+Luetke&notify_version=1.7&address_country=Canada&address_city=Ottawa&quantity=1&verify_sign=AEt48rmhLYtkZ9VzOGAtwL7rTGxUAoLNsuf7UewmX7UGvcyC3wfUmzJP&payment_type=instant&last_name=Luetke&address_state=Ontario&payment_fee=&receiver_id=UQ8PDYXJZQD9Y&txn_type=web_accept&item_name=Store+Purchase&test_ipn=1&payment_gross=&shipping=0.00'

    p "Is Transaction success : #{transaction.success}"
    p "payer id : #{payer_id}"
    p "payer status : #{payer_status}"
    p "payer email : #{payer_email}"
    p "custom : #{custom}"
    p "invoice_id : #{invoice_id}"
    p "mc_gross : #{mc_gross}"
    p "mc_currency : #{mc_currency}"
  end
  
end