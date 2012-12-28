
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
    ipn['protection_eligibility'] = 'Eligible'
    ipn['address_status'] = 'confirmed'
    ipn['tax'] = 0.00
    ipn['address_street'] = '1 Main St'
    ipn['payment_status'] = 'Completed'
    ipn['address_zip'] = '95131'
    ipn['first_name'] = 'Test'
    ipn['mc_fee'] = '0.88'
    ipn['address_country_code'] = 'US' 
    ipn['address_name'] = 'Test User'
    ipn['notify_version'] = '2.6'
    ipn['custom'] = 'nibj5o3q4m'
    ipn['payer_status'] = 'verified'
    ipn['address_country'] = 'United States'
    ipn['address_city'] = 'San Jose'
    ipn['quantity'] = 1
    ipn['payment_type'] = 'instant'
    ipn['last_name'] = 'User'
    ipn['address_state'] = 'CA'
    ipn['payment_fee'] = 0.88
    ipn['receiver_id'] = 'S8XGHLYDW9T3S'
    ipn['txn_type'] = 'express_checkout'
    ipn['item_name'] = 'product.name'
    ipn['mc_currency'] = 'USD'
    ipn['item_number'] =
    ipn['residence_country'] = 'US'
    ipn['test_ipn'] = 1
    ipn['handling_amount'] = 0.00
    ipn['transaction_subject'] =
    ipn['payment_gross'] = 2.00
    ipn['shipping'] = 0.00
        
    p 'Copy the following query:'
    p ipn.to_query + 'payment_date=15%3A23%3A54+Apr+15%2C+2012+PDT&verify_sign=AEt48rmhLYtkZ9VzOGAtwL7rTGxUAoLNsuf7UewmX7UGvcyC3wfUmzJP'
    p '--------------'
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