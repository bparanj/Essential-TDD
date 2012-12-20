require 'spec_helper'

describe FraudPolicy do
  
  context 'Spoofed receiver_email' do
    before do
      order = double('Order') 
      order.stub_chain(:product, :user, :primary_paypal_email) { 'seller@clickplan.net' }
      Order.stub(:find_by_confirmation_number) { order }    
    end

    it 'should identify spoofed receiver email' do
      notify = stub('Notify', invoice: 10, account: 'spoofer@spooky.net')
      fraud_policy = FraudPolicy.new(notify, nil, nil)

      expect(fraud_policy.spoofed_receiver_email?).to be(true)
    end

    it 'should identify non spoofed receiver email' do
      notify = stub('Notify', invoice: 10, account: 'seller@clickplan.net')
      fraud_policy = FraudPolicy.new(notify, nil, nil)

      expect(fraud_policy.spoofed_receiver_email?).to be(false)    
    end    
  end
  
  context 'Identify fraudulent changes' do
    before do
      @item_number = 1
      item_name = 'Essential TDD'
      @actual_amount = 100
      @transaction = double('Transaction')
      @transaction.stub(:amount) { @actual_amount }
      @transaction.stub(:currency) { 'USD' }      
      @notify = double('Notify')      
      @notify.stub(:currency) { 'USD' }
      @notify.stub(:item_number) { @item_number }
      @notify.stub(:item_name) { item_name }
      @order = double('Order')
      @order.stub_chain(:product, :name) { item_name }
    end
    
    it 'should identify fraudulent change when payment does not have correct amount' do
      @order.stub(:product_id) { @item_number }
      @notify.stub(:gross) { @actual_amount - 50 }

      fraud_policy = FraudPolicy.new(@notify, @transaction, @order)

      expect(fraud_policy.no_fraudulent_change?).to be(false)
    end

    it 'should not be fraudulent change when payment has correct amount' do
      @order.stub(:product_id) { @item_number }
      @notify.stub(:gross) { @actual_amount }

      fraud_policy = FraudPolicy.new(@notify, @transaction, @order)

      expect(fraud_policy.no_fraudulent_change?).to be(true)
    end    
    
    it 'should be fraudulent change when item number (product_id) is not the same' do
      @order.stub(:product_id) { 2 }
      @notify.stub(:gross) { @actual_amount }

      fraud_policy = FraudPolicy.new(@notify, @transaction, @order)

      expect(fraud_policy.no_fraudulent_change?).to be(false)      
    end
    
    it 'should not be fraudulent change when item number (product_id) is the same' do
      @order.stub(:product_id) { @item_number }
      @notify.stub(:gross) { @actual_amount }

      fraud_policy = FraudPolicy.new(@notify, @transaction, @order)
      
      expect(fraud_policy.no_fraudulent_change?).to be(true)      
    end
    
    it 'should be fraudulent change when item name (product name) is not the same' do
      @order.stub(:product_id) { @item_number }
      @notify.stub(:gross) { @actual_amount }
      @notify.stub(:item_name) { 'Sneaky Thing' }
      
      fraud_policy = FraudPolicy.new(@notify, @transaction, @order)

      expect(fraud_policy.no_fraudulent_change?).to be(false)      
    end

    it 'should not be fraudulent change when item name (product name) is the same' do
      @order.stub(:product_id) { @item_number }
      @notify.stub(:gross) { @actual_amount }
      
      fraud_policy = FraudPolicy.new(@notify, @transaction, @order)

      expect(fraud_policy.no_fraudulent_change?).to be(true)      
    end
    
  end
  

end