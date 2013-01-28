require 'spec_helper'

describe RefundProcessor do
  before do
    @notify = double('Notify')
    @notify.stub(transaction_id: 5)
    @notify.stub(currency: 'USD')
    @notify.stub(gross: '100')
    @fraud_policy = double('FraudPolicy')
  end
  
  it 'process refund if the payment notification is for a refund and payment is correct amount' do    
    @notify.stub(status: Payment::REFUNDED)
    @fraud_policy.stub(:payment_has_correct_amount?) { true }

    refund_processor = RefundProcessor.new(@notify, @fraud_policy)
    
    expect do
      refund_processor.run
    end.to change(Refund, :count).by(1)
  end
  
  it 'should not process refund if the payment notification is not for a refund' do
    @notify.stub(status: Payment::COMPLETE)
    @fraud_policy.stub(:payment_has_correct_amount?) { true }
    
    refund_processor = RefundProcessor.new(@notify, @fraud_policy)
    
    expect do
      refund_processor.run
    end.to_not change(Refund, :count)
  end

  it 'should not process refund if the payment amount is not correct' do
    @notify.stub(status: Payment::COMPLETE)
    @fraud_policy.stub(:payment_has_correct_amount?) { false }
    
    refund_processor = RefundProcessor.new(@notify, @fraud_policy)
    
    expect do
      refund_processor.run
    end.to_not change(Refund, :count)
  end
  
end