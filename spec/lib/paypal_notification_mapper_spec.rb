require 'spec_helper'

include ActiveMerchant::Billing::Integrations

describe PaypalNotificationMapper do
  let(:mapper) { PaypalNotificationMapper.new(http_raw_data) }
  
  it 'should return the item name' do
    item_name = mapper.item_name
    
    expect(item_name).to eq('Essential TDD')
  end  
  
  it 'should return the item number' do
    item_number = mapper.item_number
    
    expect(item_number).to eq('1')
  end

  it 'should return the payer_id' do
    payer_id = mapper.payer_id
    
    expect(payer_id).to eq('EVMXCLDZJV77Q')
  end

  it 'should return the payer_email' do
    payer_email = mapper.payer_email
    
    expect(payer_email).to eq('payer@snowdevil.ca')
  end
  
  it 'payment should be complete' do
    complete = mapper.complete?
    
    expect(complete).to be(true)
  end
  
  it 'should return transaction_id' do
    transaction_id = mapper.transaction_id
    
    expect(transaction_id).to eq('6G996328CK404320L')
  end
  
  it 'should return amount' do
    actual_amount = mapper.amount
    expected_amount_in_cents = Money.new(BigDecimal.new(50000), 'CAD')
    
    expect(actual_amount).to eq(expected_amount_in_cents)
  end
  
  it 'should return status' do
    status = mapper.status
    
    expect(status).to eq('Completed')
  end
  
  it 'should return test status' do
    test = mapper.test?
    
    expect(test).to be(true)
  end
  
  it 'should return the gross amount' do
    gross = mapper.gross
    
    expect(gross).to eq("500.00")
  end
  
  it 'should return the currency' do
    currency = mapper.currency
    
    expect(currency).to eq('CAD')
  end
  
  it 'should return the params' do
    expected_params = { "custom"=>"89CVZ", "mc_gross"=>"500.00", "address_status"=>"confirmed", 
                        "payer_id"=>"EVMXCLDZJV77Q", "tax"=>"0.00", "address_street"=>"164 Waverley Street", 
                        "payment_date"=>"15:23:54 Apr 15, 2005 PDT", "payment_status"=>"Completed", 
                        "address_zip"=>"K2P0V6", "first_name"=>"Tobias", "mc_fee"=>"15.05", 
                        "address_country_code"=>"CA", "address_name"=>"Tobias Luetke", "notify_version"=>"1.7", 
                        "payer_status"=>"unverified", "business"=>"biz@clickplan.net", 
                        "address_country"=>"Canada", "address_city"=>"Ottawa", "quantity"=>"1", 
                        "payer_email"=>"payer@snowdevil.ca", 
                        "verify_sign"=>"AEt48rmhLYtkZ9VzOGAtwL7rTGxUAoLNsuf7UewmX7UGvcyC3wfUmzJP", 
                        "txn_id"=>"6G996328CK404320L", "payment_type"=>"instant", "last_name"=>"Luetke", 
                        "address_state"=>"Ontario", "receiver_email"=>"receiver@clickplan.net", 
                        "payment_fee"=>"", "receiver_id"=>"UQ8PDYXJZQD9Y", "txn_type"=>"web_accept", 
                        "item_name"=>"Essential TDD", "item_number"=>"1", "mc_currency"=>"CAD", 
                        "test_ipn"=>"1", "payment_gross"=>"", "shipping"=>"0.00", "invoice"=>'R180'}
    params = mapper.params
    
    
    expect(params).to eq(expected_params)
  end
  
  it 'should return the invoice' do
    invoice = mapper.invoice
    
    expect(invoice).to eq('R180')
  end
  
  it 'should acknowlege' do
    result = mapper.acknowledge
    
    expect(result).to be(false)
  end
  
  it 'should return account' do
    account = mapper.account
    
    expect(account).to eq('biz@clickplan.net')
  end
end