require 'spec_helper'

describe InstantPaymentNotification do
  it 'should not process payment if the transaction is processed previously' do
    transaction = stub('Transaction', previously_processed?: true).as_null_object
    Transaction.stub(:find) { transaction }
    ipn = InstantPaymentNotification.new(http_raw_data) 
    
    result = ipn.process_payment
    expect(result).to be_nil
  end
  
  it 'should not process payment if the receiver email is spoofed' do
    transaction = stub('Transaction', previously_processed?: false).as_null_object
    Transaction.stub(:find) { transaction }
    fraud_policy = stub('FraudPolicy', spoofed_receiver_email?: true)
    FraudPolicy.stub(:new) { fraud_policy }
    ipn = InstantPaymentNotification.new(http_raw_data) 
    
    result = ipn.process_payment
    expect(result).to be_nil    
  end
  
  it 'create payment if the transaction is not previously processed and receiver_email is not spoofed' do
    transaction = stub('Transaction', previously_processed?: false).as_null_object
    Transaction.stub(:find) { transaction }
    fraud_policy = stub('FraudPolicy', spoofed_receiver_email?: false).as_null_object
    FraudPolicy.stub(:new) { fraud_policy }
    notify = double('Notify')
    notify.stub(:transaction_id) { 8 }
    notify.stub(:amount) { 100 }
    notify.stub(:item_name) { 'Essential TDD' }
    notify.stub(:payer_id) { 2 }
    notify.stub(:status) { 'Completed' }
    notify.stub(:test?) { 1 }
    notify.stub(:gross) { 100 }
    notify.stub(:currency) { 'USD' }
    notify.stub(:payer_email) { 'payer@bigspender.com' }
    notify.stub(:params) { {} }
    notify.stub(:invoice) { 4 }
    ipn = InstantPaymentNotification.new(http_raw_data) 

    expect do
      ipn.process_payment
    end.to change(Payment, :count).by(1)
  end
  
  it 'run bounty processor if the transaction is not previously processed and there is no fraud alert' do
    transaction = stub('Transaction', previously_processed?: false).as_null_object
    Transaction.stub(:find) { transaction }
    fraud_policy = stub('FraudPolicy', spoofed_receiver_email?: false)
    fraud_policy.stub(no_fraudulent_change?: true)
    FraudPolicy.stub(:new) { fraud_policy }
    notify = double('Notify')
    notify.stub(:transaction_id) { 8 }
    notify.stub(:amount) { 100 }
    notify.stub(:item_name) { 'Essential TDD' }
    notify.stub(:payer_id) { 2 }
    notify.stub(:status) { 'Completed' }
    notify.stub(:test?) { 1 }
    notify.stub(:gross) { 100 }
    notify.stub(:currency) { 'USD' }
    notify.stub(:payer_email) { 'payer@bigspender.com' }
    notify.stub(:params) { {} }
    notify.stub(:invoice) { 4 }
    ipn = InstantPaymentNotification.new(http_raw_data) 
    bounty_processor = double('BountyProcessor')
    BountyProcessor.stub(:new) { bounty_processor }
    bounty_processor.should_receive(:run)

    ipn.process_payment
  end

  it 'do not run bounty processor if the transaction is not previously processed and there is fraud alert' do
    transaction = stub('Transaction', previously_processed?: false).as_null_object
    Transaction.stub(:find) { transaction }
    fraud_policy = stub('FraudPolicy', spoofed_receiver_email?: false)
    fraud_policy.stub(no_fraudulent_change?: false)
    FraudPolicy.stub(:new) { fraud_policy }
    notify = double('Notify')
    notify.stub(:transaction_id) { 8 }
    notify.stub(:amount) { 100 }
    notify.stub(:item_name) { 'Essential TDD' }
    notify.stub(:payer_id) { 2 }
    notify.stub(:status) { 'Completed' }
    notify.stub(:test?) { 1 }
    notify.stub(:gross) { 100 }
    notify.stub(:currency) { 'USD' }
    notify.stub(:payer_email) { 'payer@bigspender.com' }
    notify.stub(:params) { {} }
    notify.stub(:invoice) { 4 }
    ipn = InstantPaymentNotification.new(http_raw_data) 
    bounty_processor = double('BountyProcessor')
    BountyProcessor.stub(:new) { bounty_processor }
    bounty_processor.should_not_receive(:run)

    ipn.process_payment
  end

  it 'run refund processor if the transaction is not previously processed, no fraud and notify is refund' do
    transaction = stub('Transaction', previously_processed?: false).as_null_object
    Transaction.stub(:find) { transaction }
    fraud_policy = stub('FraudPolicy', spoofed_receiver_email?: false)
    FraudPolicy.stub(:new) { fraud_policy }
    notify = double('Notify')
    notify.stub(:transaction_id) { 8 }
    notify.stub(:amount) { 100 }
    notify.stub(:item_name) { 'Essential TDD' }
    notify.stub(:payer_id) { 2 }
    notify.stub(:status) { 'Refunded' }
    notify.stub(:test?) { 1 }
    notify.stub(:gross) { 100 }
    notify.stub(:currency) { 'USD' }
    notify.stub(:payer_email) { 'payer@bigspender.com' }
    notify.stub(:params) { {} }
    notify.stub(:invoice) { 4 }
    notify.stub(:complete?) { false }
    PaypalNotificationMapper.stub(:new) { notify }
    ipn = InstantPaymentNotification.new(http_raw_data) 
    refund_processor = double('RefundProcessor')
    RefundProcessor.stub(:new) { refund_processor }
    refund_processor.should_receive(:run)

    ipn.process_payment
  end
  
end